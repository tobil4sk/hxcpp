@:include('unistd.h')
extern class Unistd {
  @:native('_SC_OPEN_MAX')
  static final _SC_OPEN_MAX:Int;

  @:native('sysconf')
  static function sysconf(name: Int):cpp.Int64;
}

@:include('fcntl.h')
extern class Fcntl {
  @:native('F_GETFD')
  static final F_GETFD:Int;

  @:native('fcntl')
  static function fcntl(fd: Int, op:Int):Int;
}

function getFileDescriptors() {
  final fileDescriptors = [];

  for (fd in 0...Unistd.sysconf(Unistd._SC_OPEN_MAX)) {
    if (Fcntl.fcntl(fd, Fcntl.F_GETFD) != -1) {
      fileDescriptors.push(fd); 
    }
  }

  return fileDescriptors;
}

function main() {
  if (!Sys.args().contains("--version")) {
    final fileDescriptors = getFileDescriptors();
    trace("child " + fileDescriptors.length + " - " + fileDescriptors);
  }
  Sys.command("g++", Sys.args());
}
