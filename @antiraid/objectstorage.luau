local ExecutorScope = require "@antiraid-core/executorscope"
local promise = require "@antiraid/promise"
local Primitives = require "@antiraid-core/primitives"

export type ObjectMetadataListPromise = promise.LuaPromise<ObjectMetadata>

--- An object storage bucket
---
--- Object storage is mainly useful over kv when dealing with blobs of data
--- (otherwise, kv is easier to use as it has support for serializing most AntiRaid types
--- etc). As an example, datetimes should be stored using object storage for automatic
--- conversion to/from the storage bit for you while object storage can be used for storing
--- compressed assets, images etc.
---
--- Object storage also works over HTTP calls and may be slower than key-value which 
--- may use a custom binary protocol over unix socket
export type Bucket = {
    --- The buckets name
    read bucket_name: string,
    --- List all files in the bucket
    list_files: (self: Bucket, prefix: string?) -> ObjectMetadataListPromise,
    --- Returns if a file exists
    file_exists: (self: Bucket, path: ObjectStoragePathLike) -> promise.LuaPromise<boolean>,
    --- Downloads a file. The resulting file must fit into the VM's memory limit
    download_file: (self: Bucket, path: ObjectStoragePathLike, opts: DownloadFileOpts?) -> promise.LuaPromise<buffer>,
    --- Creates a presigned url for referring to the file
    get_file_url: (self: Bucket, path: ObjectStoragePathLike, expiry: datetime.TimeDelta) -> promise.LuaPromise<string>,
    --- Upload a file to a bucket
    upload_file: (self: Bucket, path: ObjectStoragePathLike, data: buffer) -> promise.LuaPromise<nil>,
    --- Deletes a file from the bucket
    delete_file: (self: Bucket, path: ObjectStoragePathLike) -> promise.LuaPromise<nil>
}

local datetime = require("@antiraid/datetime")

--- Metadata about an object.
export type ObjectMetadata = {
    key: string,
    last_modified: datetime.DateTime?,
    size: number,
    etag: string?,
}

export type ObjectStorageReadRange = {
    read_start: number,
    read_end: number
}

export type DownloadFileOpts = {
    range: ObjectStorageReadRange?
}

--- A userdata type to richly denote an object storage path
export type ObjectStoragePath = {
    read path: string,
}

--- Any type that can be used as a object storage path right now
export type ObjectStoragePathLike = ObjectStoragePath | string

--- Creates a new handle to a bucket
local function new(token: Primitives.TemplateContext, scope: ExecutorScope.ExecutorScope?, kv_scope: string?): Bucket
    error("Implemented internally in AntiRaid runtime!")
end

-- Creates a new designated ObjectStoragePath
local function ObjectStoragePath(obj: ObjectStoragePathLike): ObjectStoragePath 
    error("Implemented internally in AntiRaid runtime!")
end

return {
    new = new,
    ObjectStoragePath = ObjectStoragePath
}