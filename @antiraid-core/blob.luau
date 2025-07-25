--[[
    A Blob is a special structure that is owned by Rust
    and can be used to e.g. avoid copying between Lua and Rust

    When a Blob is passed into a DataStore/Rust, its contents may be moved
    to Rust leaving a empty Blob. `clone` can be used to avoid this. When this
    will happen is undefined.

    This core primitive is not available in WASM contexts yet
]]
export type Blob = typeof(setmetatable({} :: {
    --- Converts the Blob to a buffer if there is enough memory available
    tobuffer: (self: Blob) -> buffer,
    --- Clones the Blob, creating a new Blob with the same contents
    clone: (self: Blob) -> Blob,
    --- Drains the Blob following which the Blob will be empty
    drain: (self: Blob) -> nil,
    --- Securely drains/"zeroizes" the Blob, following which the Blob will be empty
    zeroize: (self: Blob) -> nil,
    --- Encrypts the Blob using AES256 encryption (Argon2id for key derivation)
    ---
    --- Format: ``<salt><nonce><ciphertext>``
    aes256encrypt: (self: Blob, key: string) -> Blob,
    --- Decrypts the Blob using AES256 decryption (Argon2id for key derivation)
    ---
    --- Format: ``<salt><nonce><ciphertext>``
    aes256decrypt: (self: Blob, key: string) -> Blob,
}, {} :: {
    __len: (self: Blob) -> number, -- Returns the length of the blob in bytes
}))

export type BlobTaker = buffer | Blob 

return {}