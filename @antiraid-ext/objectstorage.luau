--!strict
local datetime = require("@antiraid/datetime")
local blob = require("@antiraid-core/blob")
local runtime = require("@antiraid-core/plugins/runtime")
local Primitives = require"@antiraid-core/primitives"

export type Bucket = {    
    read listfiles: (prefix: string?) -> {runtime.ObjectMetadata},
    read getfile: (path: string) -> runtime.ObjectMetadata?,
    read downloadfile: (path: string) -> blob.Blob,
    read getfileurl: (path: string, expiry: datetime.TimeDelta) -> string,
    read uploadfile: (path: string, data: blob.BlobTaker) -> (),
    read deletefile: (path: string) -> (),
}

--- Helper function to execute and unwrap the syscall
local function objstorecall(ctx: Primitives.TemplateContext, req: runtime.ObjectStorageCall): runtime.ObjectStorageResult
    local result = ctx.Runtime:syscall({
        op = "ObjectStorage",
        req = req
    })

    if result.op ~= "ObjectStorage" then
        error(`expected ObjectStorage response`, 3)
    end

    return result.res
end

--- Creates a new bucket interface
local function Bucket(ctx: Primitives.TemplateContext): Bucket
    local function listfiles(prefix: string?): {runtime.ObjectMetadata}
        local res = objstorecall(ctx, {
            op = "ListFileMetas",
            prefix = prefix
        })

        if res.op == "ObjectMetadata" then
            return res.objs
        end
        error(`[Bucket] list_files failed: unexpected response '{res.op}'`, 2)
    end

    local function getfile(path: string): runtime.ObjectMetadata?
        local res = objstorecall(ctx, {
            op = "GetFileMeta",
            key = path
        })

        if res.op == "ObjectMetadata" then 
            if #res.objs > 0 then return res.objs[1] end
        end
        return nil
    end

    local function downloadfile(path: string): blob.Blob
        local res = objstorecall(ctx, {
            op = "DownloadFile",
            key = path
        })

        if res.op == "Blob" then
            return res.data
        end
        error(`downloadfile failed: unexpected response '{res.op}'`, 2)
    end

    local function getfileurl(path: string, expiry: datetime.TimeDelta): string
        local res = objstorecall(ctx, {
            op = "GetFileUrl",
            key = path,
            expiry = expiry
        })

        if res.op == "FileUrl" then
            return res.url
        end
        error(`getfileurl failed: unexpected response '{res.op}'`, 2)
    end

    local function uploadfile(path: string, data: blob.BlobTaker)
        local res = objstorecall(ctx, {
            op = "UploadFile",
            key = path,
            data = data
        })

        if res.op ~= "Ack" then
            error(`[Bucket] upload_file failed: unexpected response '{res.op}'`, 2)
        end
    end

    local function deletefile(path: string)
        local res = objstorecall(ctx, {
            op = "DeleteFile",
            key = path
        })

        if res.op ~= "Ack" then
            error(`[Bucket] delete_file failed: unexpected response '{res.op}'`, 2)
        end
    end

    return table.freeze{
        listfiles = listfiles,
        getfile = getfile,
        downloadfile = downloadfile,
        getfileurl = getfileurl,
        uploadfile = uploadfile,
        deletefile = deletefile,
    }
end

return Bucket