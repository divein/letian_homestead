# import 'nodes/Python.pp'
file { '/tmp/hello':
   content => "Hello, world\n",
}
