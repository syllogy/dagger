# This file generated by `dagger_codegen`. Please DO NOT EDIT.
defmodule Dagger.Client do
  @moduledoc "The root of the DAG."

  use Dagger.Core.QueryBuilder

  defstruct [:selection, :client]

  @type t() :: %__MODULE__{}

  @doc "Retrieves a content-addressed blob."
  @spec blob(t(), String.t(), integer(), String.t(), String.t()) :: Dagger.Directory.t()
  def blob(%__MODULE__{} = client, digest, size, media_type, uncompressed) do
    selection =
      client.selection
      |> select("blob")
      |> put_arg("digest", digest)
      |> put_arg("size", size)
      |> put_arg("mediaType", media_type)
      |> put_arg("uncompressed", uncompressed)

    %Dagger.Directory{
      selection: selection,
      client: client.client
    }
  end

  @doc "Retrieves a container builtin to the engine."
  @spec builtin_container(t(), String.t()) :: Dagger.Container.t()
  def builtin_container(%__MODULE__{} = client, digest) do
    selection =
      client.selection |> select("builtinContainer") |> put_arg("digest", digest)

    %Dagger.Container{
      selection: selection,
      client: client.client
    }
  end

  @doc "Constructs a cache volume for a given cache key."
  @spec cache_volume(t(), String.t()) :: Dagger.CacheVolume.t()
  def cache_volume(%__MODULE__{} = client, key) do
    selection =
      client.selection |> select("cacheVolume") |> put_arg("key", key)

    %Dagger.CacheVolume{
      selection: selection,
      client: client.client
    }
  end

  @doc """
  Creates a scratch container.

  Optional platform argument initializes new containers to execute and publish as that platform. Platform defaults to that of the builder's host.
  """
  @spec container(t(), [
          {:id, Dagger.ContainerID.t() | nil},
          {:platform, Dagger.Platform.t() | nil}
        ]) :: Dagger.Container.t()
  def container(%__MODULE__{} = client, optional_args \\ []) do
    selection =
      client.selection
      |> select("container")
      |> maybe_put_arg("id", optional_args[:id])
      |> maybe_put_arg("platform", optional_args[:platform])

    %Dagger.Container{
      selection: selection,
      client: client.client
    }
  end

  @doc """
  The FunctionCall context that the SDK caller is currently executing in.

  If the caller is not currently executing in a function, this will return an error.
  """
  @spec current_function_call(t()) :: Dagger.FunctionCall.t()
  def current_function_call(%__MODULE__{} = client) do
    selection =
      client.selection |> select("currentFunctionCall")

    %Dagger.FunctionCall{
      selection: selection,
      client: client.client
    }
  end

  @doc "The module currently being served in the session, if any."
  @spec current_module(t()) :: Dagger.CurrentModule.t()
  def current_module(%__MODULE__{} = client) do
    selection =
      client.selection |> select("currentModule")

    %Dagger.CurrentModule{
      selection: selection,
      client: client.client
    }
  end

  @doc "The TypeDef representations of the objects currently being served in the session."
  @spec current_type_defs(t()) :: {:ok, [Dagger.TypeDef.t()]} | {:error, term()}
  def current_type_defs(%__MODULE__{} = client) do
    selection =
      client.selection |> select("currentTypeDefs") |> select("id")

    with {:ok, items} <- execute(selection, client.client) do
      {:ok,
       for %{"id" => id} <- items do
         %Dagger.TypeDef{
           selection:
             query()
             |> select("loadTypeDefFromID")
             |> arg("id", id),
           client: client.client
         }
       end}
    end
  end

  @doc "The default platform of the engine."
  @spec default_platform(t()) :: {:ok, Dagger.Platform.t()} | {:error, term()}
  def default_platform(%__MODULE__{} = client) do
    selection =
      client.selection |> select("defaultPlatform")

    execute(selection, client.client)
  end

  @doc "Creates an empty directory."
  @spec directory(t(), [{:id, Dagger.DirectoryID.t() | nil}]) :: Dagger.Directory.t()
  def directory(%__MODULE__{} = client, optional_args \\ []) do
    selection =
      client.selection |> select("directory") |> maybe_put_arg("id", optional_args[:id])

    %Dagger.Directory{
      selection: selection,
      client: client.client
    }
  end

  @deprecated "Use `load_file_from_id` instead."

  @spec file(t(), Dagger.FileID.t()) :: Dagger.File.t()
  def file(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("file") |> put_arg("id", id)

    %Dagger.File{
      selection: selection,
      client: client.client
    }
  end

  @doc "Creates a function."
  @spec function(t(), String.t(), Dagger.TypeDef.t()) :: Dagger.Function.t()
  def function(%__MODULE__{} = client, name, return_type) do
    selection =
      client.selection
      |> select("function")
      |> put_arg("name", name)
      |> put_arg("returnType", Dagger.ID.id!(return_type))

    %Dagger.Function{
      selection: selection,
      client: client.client
    }
  end

  @doc "Create a code generation result, given a directory containing the generated code."
  @spec generated_code(t(), Dagger.Directory.t()) :: Dagger.GeneratedCode.t()
  def generated_code(%__MODULE__{} = client, code) do
    selection =
      client.selection |> select("generatedCode") |> put_arg("code", Dagger.ID.id!(code))

    %Dagger.GeneratedCode{
      selection: selection,
      client: client.client
    }
  end

  @doc "Queries a Git repository."
  @spec git(t(), String.t(), [
          {:keep_git_dir, boolean() | nil},
          {:experimental_service_host, Dagger.ServiceID.t() | nil},
          {:ssh_known_hosts, String.t() | nil},
          {:ssh_auth_socket, Dagger.SocketID.t() | nil}
        ]) :: Dagger.GitRepository.t()
  def git(%__MODULE__{} = client, url, optional_args \\ []) do
    selection =
      client.selection
      |> select("git")
      |> put_arg("url", url)
      |> maybe_put_arg("keepGitDir", optional_args[:keep_git_dir])
      |> maybe_put_arg("experimentalServiceHost", optional_args[:experimental_service_host])
      |> maybe_put_arg("sshKnownHosts", optional_args[:ssh_known_hosts])
      |> maybe_put_arg("sshAuthSocket", optional_args[:ssh_auth_socket])

    %Dagger.GitRepository{
      selection: selection,
      client: client.client
    }
  end

  @doc "Queries the host environment."
  @spec host(t()) :: Dagger.Host.t()
  def host(%__MODULE__{} = client) do
    selection =
      client.selection |> select("host")

    %Dagger.Host{
      selection: selection,
      client: client.client
    }
  end

  @doc "Returns a file containing an http remote url content."
  @spec http(t(), String.t(), [{:experimental_service_host, Dagger.ServiceID.t() | nil}]) ::
          Dagger.File.t()
  def http(%__MODULE__{} = client, url, optional_args \\ []) do
    selection =
      client.selection
      |> select("http")
      |> put_arg("url", url)
      |> maybe_put_arg("experimentalServiceHost", optional_args[:experimental_service_host])

    %Dagger.File{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a CacheVolume from its ID."
  @spec load_cache_volume_from_id(t(), Dagger.CacheVolumeID.t()) :: Dagger.CacheVolume.t()
  def load_cache_volume_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadCacheVolumeFromID") |> put_arg("id", id)

    %Dagger.CacheVolume{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a Container from its ID."
  @spec load_container_from_id(t(), Dagger.ContainerID.t()) :: Dagger.Container.t()
  def load_container_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadContainerFromID") |> put_arg("id", id)

    %Dagger.Container{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a CurrentModule from its ID."
  @spec load_current_module_from_id(t(), Dagger.CurrentModuleID.t()) :: Dagger.CurrentModule.t()
  def load_current_module_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadCurrentModuleFromID") |> put_arg("id", id)

    %Dagger.CurrentModule{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a Directory from its ID."
  @spec load_directory_from_id(t(), Dagger.DirectoryID.t()) :: Dagger.Directory.t()
  def load_directory_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadDirectoryFromID") |> put_arg("id", id)

    %Dagger.Directory{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a EnumTypeDef from its ID."
  @spec load_enum_type_def_from_id(t(), Dagger.EnumTypeDefID.t()) :: Dagger.EnumTypeDef.t()
  def load_enum_type_def_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadEnumTypeDefFromID") |> put_arg("id", id)

    %Dagger.EnumTypeDef{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a EnumValueTypeDef from its ID."
  @spec load_enum_value_type_def_from_id(t(), Dagger.EnumValueTypeDefID.t()) ::
          Dagger.EnumValueTypeDef.t()
  def load_enum_value_type_def_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadEnumValueTypeDefFromID") |> put_arg("id", id)

    %Dagger.EnumValueTypeDef{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a EnvVariable from its ID."
  @spec load_env_variable_from_id(t(), Dagger.EnvVariableID.t()) :: Dagger.EnvVariable.t()
  def load_env_variable_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadEnvVariableFromID") |> put_arg("id", id)

    %Dagger.EnvVariable{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a FieldTypeDef from its ID."
  @spec load_field_type_def_from_id(t(), Dagger.FieldTypeDefID.t()) :: Dagger.FieldTypeDef.t()
  def load_field_type_def_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadFieldTypeDefFromID") |> put_arg("id", id)

    %Dagger.FieldTypeDef{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a File from its ID."
  @spec load_file_from_id(t(), Dagger.FileID.t()) :: Dagger.File.t()
  def load_file_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadFileFromID") |> put_arg("id", id)

    %Dagger.File{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a FunctionArg from its ID."
  @spec load_function_arg_from_id(t(), Dagger.FunctionArgID.t()) :: Dagger.FunctionArg.t()
  def load_function_arg_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadFunctionArgFromID") |> put_arg("id", id)

    %Dagger.FunctionArg{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a FunctionCallArgValue from its ID."
  @spec load_function_call_arg_value_from_id(t(), Dagger.FunctionCallArgValueID.t()) ::
          Dagger.FunctionCallArgValue.t()
  def load_function_call_arg_value_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadFunctionCallArgValueFromID") |> put_arg("id", id)

    %Dagger.FunctionCallArgValue{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a FunctionCall from its ID."
  @spec load_function_call_from_id(t(), Dagger.FunctionCallID.t()) :: Dagger.FunctionCall.t()
  def load_function_call_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadFunctionCallFromID") |> put_arg("id", id)

    %Dagger.FunctionCall{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a Function from its ID."
  @spec load_function_from_id(t(), Dagger.FunctionID.t()) :: Dagger.Function.t()
  def load_function_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadFunctionFromID") |> put_arg("id", id)

    %Dagger.Function{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a GeneratedCode from its ID."
  @spec load_generated_code_from_id(t(), Dagger.GeneratedCodeID.t()) :: Dagger.GeneratedCode.t()
  def load_generated_code_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadGeneratedCodeFromID") |> put_arg("id", id)

    %Dagger.GeneratedCode{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a GitModuleSource from its ID."
  @spec load_git_module_source_from_id(t(), Dagger.GitModuleSourceID.t()) ::
          Dagger.GitModuleSource.t()
  def load_git_module_source_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadGitModuleSourceFromID") |> put_arg("id", id)

    %Dagger.GitModuleSource{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a GitRef from its ID."
  @spec load_git_ref_from_id(t(), Dagger.GitRefID.t()) :: Dagger.GitRef.t()
  def load_git_ref_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadGitRefFromID") |> put_arg("id", id)

    %Dagger.GitRef{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a GitRepository from its ID."
  @spec load_git_repository_from_id(t(), Dagger.GitRepositoryID.t()) :: Dagger.GitRepository.t()
  def load_git_repository_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadGitRepositoryFromID") |> put_arg("id", id)

    %Dagger.GitRepository{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a Host from its ID."
  @spec load_host_from_id(t(), Dagger.HostID.t()) :: Dagger.Host.t()
  def load_host_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadHostFromID") |> put_arg("id", id)

    %Dagger.Host{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a InputTypeDef from its ID."
  @spec load_input_type_def_from_id(t(), Dagger.InputTypeDefID.t()) :: Dagger.InputTypeDef.t()
  def load_input_type_def_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadInputTypeDefFromID") |> put_arg("id", id)

    %Dagger.InputTypeDef{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a InterfaceTypeDef from its ID."
  @spec load_interface_type_def_from_id(t(), Dagger.InterfaceTypeDefID.t()) ::
          Dagger.InterfaceTypeDef.t()
  def load_interface_type_def_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadInterfaceTypeDefFromID") |> put_arg("id", id)

    %Dagger.InterfaceTypeDef{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a Label from its ID."
  @spec load_label_from_id(t(), Dagger.LabelID.t()) :: Dagger.Label.t()
  def load_label_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadLabelFromID") |> put_arg("id", id)

    %Dagger.Label{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a ListTypeDef from its ID."
  @spec load_list_type_def_from_id(t(), Dagger.ListTypeDefID.t()) :: Dagger.ListTypeDef.t()
  def load_list_type_def_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadListTypeDefFromID") |> put_arg("id", id)

    %Dagger.ListTypeDef{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a LocalModuleSource from its ID."
  @spec load_local_module_source_from_id(t(), Dagger.LocalModuleSourceID.t()) ::
          Dagger.LocalModuleSource.t()
  def load_local_module_source_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadLocalModuleSourceFromID") |> put_arg("id", id)

    %Dagger.LocalModuleSource{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a ModuleDependency from its ID."
  @spec load_module_dependency_from_id(t(), Dagger.ModuleDependencyID.t()) ::
          Dagger.ModuleDependency.t()
  def load_module_dependency_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadModuleDependencyFromID") |> put_arg("id", id)

    %Dagger.ModuleDependency{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a Module from its ID."
  @spec load_module_from_id(t(), Dagger.ModuleID.t()) :: Dagger.Module.t()
  def load_module_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadModuleFromID") |> put_arg("id", id)

    %Dagger.Module{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a ModuleSource from its ID."
  @spec load_module_source_from_id(t(), Dagger.ModuleSourceID.t()) :: Dagger.ModuleSource.t()
  def load_module_source_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadModuleSourceFromID") |> put_arg("id", id)

    %Dagger.ModuleSource{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a ModuleSourceView from its ID."
  @spec load_module_source_view_from_id(t(), Dagger.ModuleSourceViewID.t()) ::
          Dagger.ModuleSourceView.t()
  def load_module_source_view_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadModuleSourceViewFromID") |> put_arg("id", id)

    %Dagger.ModuleSourceView{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a ObjectTypeDef from its ID."
  @spec load_object_type_def_from_id(t(), Dagger.ObjectTypeDefID.t()) :: Dagger.ObjectTypeDef.t()
  def load_object_type_def_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadObjectTypeDefFromID") |> put_arg("id", id)

    %Dagger.ObjectTypeDef{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a Port from its ID."
  @spec load_port_from_id(t(), Dagger.PortID.t()) :: Dagger.Port.t()
  def load_port_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadPortFromID") |> put_arg("id", id)

    %Dagger.Port{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a ScalarTypeDef from its ID."
  @spec load_scalar_type_def_from_id(t(), Dagger.ScalarTypeDefID.t()) :: Dagger.ScalarTypeDef.t()
  def load_scalar_type_def_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadScalarTypeDefFromID") |> put_arg("id", id)

    %Dagger.ScalarTypeDef{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a Secret from its ID."
  @spec load_secret_from_id(t(), Dagger.SecretID.t()) :: Dagger.Secret.t()
  def load_secret_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadSecretFromID") |> put_arg("id", id)

    %Dagger.Secret{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a Service from its ID."
  @spec load_service_from_id(t(), Dagger.ServiceID.t()) :: Dagger.Service.t()
  def load_service_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadServiceFromID") |> put_arg("id", id)

    %Dagger.Service{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a Socket from its ID."
  @spec load_socket_from_id(t(), Dagger.SocketID.t()) :: Dagger.Socket.t()
  def load_socket_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadSocketFromID") |> put_arg("id", id)

    %Dagger.Socket{
      selection: selection,
      client: client.client
    }
  end

  @doc "Load a TypeDef from its ID."
  @spec load_type_def_from_id(t(), Dagger.TypeDefID.t()) :: Dagger.TypeDef.t()
  def load_type_def_from_id(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("loadTypeDefFromID") |> put_arg("id", id)

    %Dagger.TypeDef{
      selection: selection,
      client: client.client
    }
  end

  @doc "Create a new module."
  @spec module(t()) :: Dagger.Module.t()
  def module(%__MODULE__{} = client) do
    selection =
      client.selection |> select("module")

    %Dagger.Module{
      selection: selection,
      client: client.client
    }
  end

  @doc "Create a new module dependency configuration from a module source and name"
  @spec module_dependency(t(), Dagger.ModuleSource.t(), [{:name, String.t() | nil}]) ::
          Dagger.ModuleDependency.t()
  def module_dependency(%__MODULE__{} = client, source, optional_args \\ []) do
    selection =
      client.selection
      |> select("moduleDependency")
      |> put_arg("source", Dagger.ID.id!(source))
      |> maybe_put_arg("name", optional_args[:name])

    %Dagger.ModuleDependency{
      selection: selection,
      client: client.client
    }
  end

  @doc "Create a new module source instance from a source ref string."
  @spec module_source(t(), String.t(), [{:stable, boolean() | nil}]) :: Dagger.ModuleSource.t()
  def module_source(%__MODULE__{} = client, ref_string, optional_args \\ []) do
    selection =
      client.selection
      |> select("moduleSource")
      |> put_arg("refString", ref_string)
      |> maybe_put_arg("stable", optional_args[:stable])

    %Dagger.ModuleSource{
      selection: selection,
      client: client.client
    }
  end

  @doc "Creates a named sub-pipeline."
  @spec pipeline(t(), String.t(), [
          {:description, String.t() | nil},
          {:labels, [Dagger.PipelineLabel.t()]}
        ]) :: Dagger.Client.t()
  def pipeline(%__MODULE__{} = client, name, optional_args \\ []) do
    selection =
      client.selection
      |> select("pipeline")
      |> put_arg("name", name)
      |> maybe_put_arg("description", optional_args[:description])
      |> maybe_put_arg("labels", optional_args[:labels])

    %Dagger.Client{
      selection: selection,
      client: client.client
    }
  end

  @doc "Reference a secret by name."
  @spec secret(t(), String.t(), [{:accessor, String.t() | nil}]) :: Dagger.Secret.t()
  def secret(%__MODULE__{} = client, name, optional_args \\ []) do
    selection =
      client.selection
      |> select("secret")
      |> put_arg("name", name)
      |> maybe_put_arg("accessor", optional_args[:accessor])

    %Dagger.Secret{
      selection: selection,
      client: client.client
    }
  end

  @doc """
  Sets a secret given a user defined name to its plaintext and returns the secret.

  The plaintext value is limited to a size of 128000 bytes.
  """
  @spec set_secret(t(), String.t(), String.t()) :: Dagger.Secret.t()
  def set_secret(%__MODULE__{} = client, name, plaintext) do
    selection =
      client.selection
      |> select("setSecret")
      |> put_arg("name", name)
      |> put_arg("plaintext", plaintext)

    %Dagger.Secret{
      selection: selection,
      client: client.client
    }
  end

  @deprecated "Use `load_socket_from_id` instead."
  @doc "Loads a socket by its ID."
  @spec socket(t(), Dagger.SocketID.t()) :: Dagger.Socket.t()
  def socket(%__MODULE__{} = client, id) do
    selection =
      client.selection |> select("socket") |> put_arg("id", id)

    %Dagger.Socket{
      selection: selection,
      client: client.client
    }
  end

  @doc "Create a new TypeDef."
  @spec type_def(t()) :: Dagger.TypeDef.t()
  def type_def(%__MODULE__{} = client) do
    selection =
      client.selection |> select("typeDef")

    %Dagger.TypeDef{
      selection: selection,
      client: client.client
    }
  end

  @doc "Get the current Dagger Engine version."
  @spec version(t()) :: {:ok, String.t()} | {:error, term()}
  def version(%__MODULE__{} = client) do
    selection =
      client.selection |> select("version")

    execute(selection, client.client)
  end
end
