local datetime = require("@antiraid/datetime")

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

    --- @yields
    ---
    --- List all files in the bucket
    list_files: (self: Bucket, prefix: string?) -> {ObjectMetadata},
    
    --- @yields
    ---
    --- Returns if a file exists
    file_exists: (self: Bucket, path: string) -> boolean,

    --- @yields
    ---
    --- Downloads a file. The resulting file must fit into the VM's memory limit
    download_file: (self: Bucket, path: string, opts: DownloadFileOpts?) -> buffer,

    --- @yields
    ---
    --- Creates a presigned url for referring to the file
    get_file_url: (self: Bucket, path: string, expiry: datetime.TimeDelta) -> string,

    --- @yields
    ---
    --- Upload a file to a bucket
    upload_file: (self: Bucket, path: string, data: buffer) -> nil,

    --- @yields
    ---
    --- Deletes a file from the bucket
    delete_file: (self: Bucket, path: string) -> nil
}

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

export type Plugin = Bucket

return {}