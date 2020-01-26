Basic Collections Mod v1.0
By Leslie E. Krause

Basic Collections includes an assortment of helper classes for working with collections,
including membership sets, enumerated lists, and bijective maps. While all three data 
structures have differing constraints, they are otherwise based on Lua tables.

The available class constructors for membership sets are as follows:

   StaticSet( list )
   Creates an immutable membership set object.

   *  'list' is an ordered array from which to create the collection. Duplicate values
      will simply be ignored.

   >  Example:
   >  local player_privs = StaticSet { "shout", "interact" }

   The StaticSet class defines two read-only public properties:

      StaticSet::length
      The number of elements in the collection.

      >  Example:
      >  print( "You are assigned " .. player_privs.length .. " privileges." )
      >  -- outputs "You are assigned 2 privileges."

      StaticSet::elems[ val ]
      An associative array of booleans indicating which values exist in the collection.
      This permits element validation using shorthand index-notation.

      >  Example:
      >  if not player_privs.elems.server then
      >          print( "You have insufficient privileges." )
      >  end

   The StaticSet class defines two public methods:

      StaticSet::iterate( )
      Returns a function for iterating over values within the collection.

      >  Example:
      >  print( "Player has " .. player_privs.length .. " privileges:" )
      >  for priv in player_privs.iterate( ) then
      >          print( priv )
      >  end

      StaticSet::has_value( val )
      Returns true if the given value exists in the collection.

      >  Example:
      >  if not player_privs.has_value( "server" ) then
      >          print( "You have insufficient privileges." )
      >  end

   Set( list )
   Creates a mutable membership set object, inheriting all methods and properties of its
   parent class, StaticSet.

   *  'list' is an ordered array from which to create the collection. Duplicate values
      will simply be ignored.

   The Set class defines three additional public methods:

      Set::insert( val, ... )
      Inserts one or more values into the collection.

      >  Example:
      >  player_privs.insert( "basic_privs" )

      Set::remove( val, ... )
      Removes one or more values from the collection.

      >  Example:
      >  player_privs.remove( "interact", "shout" )

      Set::clear( )
      Clears all elements from the collection.

      >  Example:
      >  player_privs.clear( )

The available class constructors for enumerated lists are as follows:

   StaticEnum( list )
   Creates an immutable enumerated list object.

   *  'list' is an ordered array from which to create the collection. Duplicate values
      will result in an exception.

   >  Example:
   >  local rank_defs = Enum { "owner", "admin", "staff", "basic", "guest" }

   The StaticEnum class defines three read-only public properties:

      StaticEnum::length
      The number of elements in the collection.

      StaticEnum::values[ key ]
      An ordered array of values indexed by key within the collection.

      StaticEnum::keys[ val ]
      An associative array of numeric keys indexed by value within the collection.

   The StaticEnum class defines six public methods:

      StaticEnum::iterate( )
      Returns a function for iterating over key-value pairs within the collection

      StaticEnum::concat( sep )
      Returns a string by concatenating all values of the collection with the given separator

      StaticEnum::has_key( key )
      Returns true of the given numeric key exists in the collection

      StaticEnum::has_value( key )
      Returns true if the given value exists in the collection

      StaticEnum::value_of( key )
      Returns the value of the given numeric key in the collection, and is equivalent to the
      property StaticEnum::values[ ]

      StaticEnum::key_of( val )
      Returns the numeric key of the given value in the collection, and is equivalent to the
      property StaticEnum::keys[ ]

   Enum( list )
   Creates a mutable enumerated list object, inheriting all methods and properties of its
   parent class, StaticEnum.

   *  'list' is an ordered array from which to create the collection. Duplicate values
      will result in an exception.

   The Enum class defines six public methods:

      Enum::assign( key, val )
      Changes the value of the given numeric key in the collection. If the key 
      doesn't exist or the value already exists, an exception will be raised.

      >  Example:
      >  if rank_defs.has_key( 3 ) then
      >          rank_defs.assign( 3, "guest" )
      >  end

      Enum::reassign( val, key )
      Changes the numeric key of the given value in the collection. If the value doesn't 
      exist or the key alreaedy exists, an exception will be raised.

      >  Example:
      >  if rank_defs.has_value( "guest" ) then
      >          rank_defs.reassign( "guest", 4 )
      >  end

      Enum::insert( key, val )
      Inserts the given value into the collection with the given numeric key. If either 
      the numeric key or the value already exists, an exception will be raised.

      >  Example:
      >  rank_defs.insert( 3, "guest" )

      Enum::remove( key )
      Removes an element from the collection by the given key. If the key doesn't exist, 
      the collection will be unchanged.

      >  Example:
      >  rank_defs.unassign( rank_defs.values[ 1 ] )
      >  rank_defs.remove( 1 )    -- same as statement above

      Enum::unassign( val )
      Removes an element from the collection by the given value. If the value doesn't 
      exist, the collection will be unchanged.

      >  Example:
      >  rank_defs.remove( rank_defs.key_of( "guest" ) )
      >  rank_defs.unassign( "guest" )	-- same as statement above

      Enum::clear( )
      Removes all elements from the collection.

The available class constructors for bijective maps are as follows:

   StaticDict( hash )
   Creates an immutable bijective map object.

   *  'hash' is an asasociative array from which to create the collection. Duplicate 
      values will result in an exception.

   >  Example:
   >  local store_aliases StaticDict {
   >          city = "Builder's Shop",
   >          mine = "Miner's Shop",
   >          farm = "Farmer's Shop",
   >          misc = "Specialty Shop"
   >  }

   The StaticDict class defines three read-only public properties:

      StaticDict::length
      The number of elements in the collection.

      StaticDict::values[ key ]
      An ordered array of values indexed by key within the collection.

      StaticDict::keys[ val ]
      An associative array of keys indexed by value within the collection.

   The StaticDict class defines five public methods:

      StaticDict::iterate( )
      Returns a function for iterating over key-value pairs within the collection

      StaticDict::has_key( key )
      Returns true of the given key exists in the collection

      StaticDict::has_value( key )
      Returns true if the given value exists in the collection

      StaticDict::value_of( key )
      Returns the value of the given key in the collection, and is equivalent to the
      property StaticEnum::values[ ]

      StaticDict::key_of( val )
      Returns the key of the given value in the collection, and is equivalent to the
      property StaticEnum::keys[ ]

   Dict( list )
   Creates a mutable bijective map object, inheriting all methods and properties of its
   parent class, StaticDict.

   *  'list' is an associative array from which to create the collection. Duplicate 
      values will result in an exception.

   The Dict class defines six public methods:

      Dict::assign( key, val )
      Changes the value of the given key in the collection. If the key doesn't exist or 
      the value already exists, an exception will be raised.

      Dict::reassign( val, key )
      Changes the key of the given value in the collection. If the value doesn't exist or 
      the key alreaedy exists, an exception will be raised.

      Dict::insert( key, val )
      Inserts the given value into the collection with the given key. If either the key 
      or the value already exists, an exception will be raised.

      Dict::remove( key )
      Removes an element from the collection by the given key. If the key doesn't exist, 
      the collection will be unchanged.

      Dict::unassign( val )
      Removes an element from the collection by the given value. If the value doesn't 
      exist, the collection will be unchanged.

      Dict::clear( )
      Removes all elements from the collection.


Repository
----------------------

Browse source code...
  https://bitbucket.org/sorcerykid/collections

Download archive...
  https://bitbucket.org/sorcerykid/collections/get/master.zip
  https://bitbucket.org/sorcerykid/collections/get/master.tar.gz

Installation
----------------------

  1) Unzip the archive into the mods directory of your game
  2) Rename the collections-master directory to "collections"
  3) Add "collections" as a dependency to any mods using the API


Source Code License
----------------------

The MIT License (MIT)

Copyright (c) 2020, Leslie Krause (leslie@searstower.org)

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

For more details:
https://opensource.org/licenses/MIT
