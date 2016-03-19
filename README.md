# Lua bloom filter

Pure luajit implementation of [bloom filter](https://en.wikipedia.org/wiki/Bloom_filter) (probabilistic data structure usable for storing many values effectively).

- Based on https://github.com/mozilla-services/lua_bloom_filter
- Using https://github.com/szensk/luaxxhash (reason why this is lujit only)
- Thanks to https://github.com/moteus/lua-travis-example for lua travis example

## Install
luaxxhash is provided as submodule - clone recursively

`git clone --recursive`

## Example
```lua
local bloom_filter = require "bloom_filter"
-- store 100 items with maximal 1% error
local bf = bloom_filter.new(100, 0.01)
bf:query("a") -- 0
bf:add("a") -- 1 - it was not present yet
bf:query("a") -- 1
bf:query("a") -- 0
```
## API
### Create
`BloomFilter.new(count, probability)`

`BloomFilter.__new(count, probability)` You have to provide data manually

### Add
`BloomFilter:add(value)` Returns 0 if already present else 1
### Query
`BloomFilter:query(value)` Returns 1 if present else 0
### Clear
`BloomFilter:clear(value)` Clears all data 
### Store and load
`local bf_store = BloomFilter:store(value)` Stores bloom filter to table with fields (data, items, probability)

`BloomFilter.load(bf_store)` Load previously stored data
## Test

`luajit test/test.lua`
## TODO
[ ] luarocks (any help would be very much appreciated)

### Development

Feel free to contribute with PR.

### Copyright and License

&copy; 2016 [Vít Listík](http://tivvit.cz)

Released under [MIT licence](https://github.com/tivvit/pure-lua-bloom-filter/blob/master/LICENSE)
