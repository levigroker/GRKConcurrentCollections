GRKConcurrentCollections
===========
Threadsafe collections for Objective C.

A collection of classes which encapsulate NSMutableArray, NSMutableDictionary, and NSMutableSet for
threadsafe concurrent read and write access. Inspired by [a post by Mike Ash](http://www.mikeash.com/pyblog/friday-qa-2011-10-14-whats-new-in-gcd.html).

#### Future Ideas

* More comprehensive tests.
* Additional collection types.

### Installing

If you're using [CocoPods](http://cocopods.org) it's as simple as adding this to your
`Podfile`:

	pod 'GRKConcurrentCollections'

otherwise, simply add the contents of the `GRKConcurrentCollections` subdirectory to your
project.

### Documentation

To use, simply import the header for the collection you want to use:

	#import "GRKConcurrentMutableArray.h"
	#import "GRKConcurrentMutableDictionary.h"
	#import "GRKConcurrentMutableSet.h"
    
Then you can use instances of the same to perform read and write operations to the
instances from multiple threads without being concerned about collisions.

Please note that when modifying the contents of the collections from multiple threads, the
actual contents will be unpredictable due to thread scheduling. One should consider using
the "Snapshot" methods to get the contents at any one particular time, or the
`augmentWithBlock:` method to perform a sequence of operations on the collection without
being concerned about concurrency.

Additional documentation is available in each header file.

#### Disclaimer and Licence

* Inspiration was taken from [http://www.mikeash.com/pyblog/friday-qa-2011-10-14-whats-new-in-gcd.html](http://www.mikeash.com/pyblog/friday-qa-2011-10-14-whats-new-in-gcd.html)
* A hat tip to Tom Jendrzejek for the brilliant `augmentWithBlock:` idea.
* This work is licensed under the [Creative Commons Attribution 3.0 Unported License](http://creativecommons.org/licenses/by/3.0/).
  Please see the included LICENSE.txt for complete details.

#### About

A professional iOS engineer by day, my name is Levi Brown. Authoring a blog
[grokin.gs](http://grokin.gs), I am reachable via:

Twitter [@levigroker](https://twitter.com/levigroker)  
App.net [@levigroker](https://alpha.app.net/levigroker)  
Email [levigroker@gmail.com](mailto:levigroker@gmail.com)  

Your constructive comments and feedback are always welcome.
