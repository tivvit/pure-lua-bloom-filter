print("------------------------------------")
print("Lua version: " .. (jit and jit.version or _VERSION))
print("------------------------------------")
print("")

local HAS_RUNNER = not not lunit
local lunit = require "lunit"
local TEST_CASE = lunit.TEST_CASE

local LUA_VER = _VERSION

local _ENV = TEST_CASE "bloom_filter_test_case"

BloomFilter = require "bloom_filter"

-- is the World still sane?
function test_true()
    assert_true(true)
    -- don't be so negative
    assert_false(false)
end

function test_new()
    assert_function(BloomFilter.new)
    local bf = BloomFilter.new(10, 0.1)
    --    assert_equal(10, bf.items)
    --    assert_equal(0.1, bf.probability)
end

function test_add()
    local bf = BloomFilter.new(10, 0.1)
    assert_equal(0, bf:query("a"))
    assert_equal(1, bf:add("a"))
    assert_equal(1, bf:query("a"))
    assert_equal(0, bf:add("a"))
    assert_equal(1, bf:query("a"))
end

function test_clear()
    local bf = BloomFilter.new(10, 0.1)
    assert_equal(0, bf:query("a"))
    bf:add("a")
    assert_equal(1, bf:query("a"))
    bf:clear()
    assert_equal(0, bf:query("a"))
end

function test_range()
    local bf = BloomFilter.new(10, 0.1)
    for i = 0, 10 do
        assert_equal(0, bf:query(i))
    end

    -- add 6
    for i = 0, 5 do
        bf:add(i)
    end
    local found = 0
    for i = 0, 10 do
        found = found + bf:query(i)
    end
    assert_equal(6, found)

    -- add all
    for i = 0, 10 do
        bf:add(i)
    end
    local found = 0
    for i = 0, 10 do
        found = found + bf:query(i)
    end
    assert_equal(11, found)
end

function test_dream_big()
    local bf = BloomFilter.new(10000, 0.01)
    for i = 0, 10000 do
        assert_equal(0, bf:query(i))
    end

    for i = 0, 10000 do
        bf:add(i)
    end
    local found = 0
    for i = 0, 10000 do
        found = found + bf:query(i)
    end
    assert_equal(10001, found)
end

function test_store()
    local bf = BloomFilter.new(10, 0.1)
    local store = bf:store()
    --    assert_equal(3, table.getn(store))
    assert_equal(7, table.getn(store.data))
    assert_equal(10, store.items)
    assert_equal(0.1, store.probability)

    bf:add("a")
    local store = bf:store()
    local bf_load = BloomFilter.load(store)
    --    assert_equal(10, bf_load.items)
    assert_equal(0.1, bf_load.probability)
    assert_equal(0, bf_load:query("b"))
    assert_equal(1, bf_load:query("a"))
    bf_load:add("b")
    assert_equal(1, bf_load:query("b"))
end

if not HAS_RUNNER then lunit.run() end
