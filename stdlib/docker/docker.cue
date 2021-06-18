// Docker container operations
package docker

import (
	"alpha.dagger.io/dagger"
	"alpha.dagger.io/alpine"
	"alpha.dagger.io/dagger/op"
)

// Build a Docker image from source, using included Dockerfile
#Build: {
	source: dagger.#Artifact @dagger(input)

	#up: [
		op.#DockerBuild & {
			context: source
		},
	]

}

// Pull a docker container
#Pull: {
	// Remote ref (example: "index.docker.io/alpine:latest")
	from: string @dagger(input)

	#up: [
		op.#FetchContainer & {ref: from},
	]
}

// Push a docker image to a remote registry
#Push: {
	// Remote name (example: "index.docker.io/alpine:latest")
	name: string @dagger(input)

	// Image source
	source: dagger.#Artifact @dagger(input)

	// Registry auth
	auth: {
		// Username
		username: string @dagger(input)

		// Password or secret
		secret: string @dagger(input)
	}

	push: #up: [
		op.#Load & {from: source},

		if auth != _|_ {
			op.#DockerLogin & {
				target:   name
				username: auth.username
				secret:   auth.secret
			}
		},

		op.#PushContainer & {ref: name},

		op.#Subdir & {dir: "/dagger"},
	]

	// Image ref
	ref: string @dagger(output)

	// Image digest
	digest: string @dagger(output)

	#up: [
		op.#Load & {from: alpine.#Image & {
			package: {
				bash: true
				jq:   true
			}
		}},

		op.#Exec & {
			always: true
			args: ["/bin/bash", "-c", #"""
					jq --arg key0 'ref' --arg value0 $(cat /dagger/image_ref) 			\
						 --arg key1 'digest' --arg value1 $(cat /dagger/image_digest) \
						 '. | .[$key0]=$value0 | .[$key1]=$value1 '<<< '{}' > /out
				"""#,
			]
			mount: "/dagger": from: push
		},

		op.#Export & {
			source: "/out"
			format: "json"
		},
	]
}

#Run: {
	// Connect to a remote SSH server
	ssh: {
		// ssh host
		host: string @dagger(input)

		// ssh user
		user: string @dagger(input)

		// ssh port
		port: *22 | int @dagger(input)

		// private key
		key: dagger.#Secret @dagger(input)

		// fingerprint
		fingerprint?: string @dagger(input)

		// ssh key passphrase
		keyPassphrase?: dagger.#Secret @dagger(input)
	}

	// Image reference (e.g: nginx:alpine)
	ref: string @dagger(input)

	// Container name
	name?: string @dagger(input)

	// Image registry
	registry?: {
		target:   string
		username: string
		secret:   dagger.#Secret
	} @dagger(input)

	#command: #"""
		# Run detach container
		OPTS=""

		if [ ! -z "$CONTAINER_NAME" ]; then
			OPTS="$OPTS --name $CONTAINER_NAME"
		fi

		docker container run -d $OPTS "$IMAGE_REF"
		"""#

	run: #Command & {
		"ssh":   ssh
		command: #command
		env: {
			IMAGE_REF: ref
			if name != _|_ {
				CONTAINER_NAME: name
			}
		}
	}
}

// Build a Docker image from the provided Dockerfile contents
// FIXME: incorporate into #Build
#ImageFromDockerfile: {
	// Dockerfile passed as a string
	dockerfile: string @dagger(input)

	// Build context
	context: dagger.#Artifact @dagger(input)

	#up: [
		op.#DockerBuild & {
			"context":    context
			"dockerfile": dockerfile
		},
	]
}
