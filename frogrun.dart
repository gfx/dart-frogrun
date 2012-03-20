#!/usr/bin/env dart
// vim: set ft=dart :

#import("dart:io");

final bool DEBUG = false;

void info(message) {
    if(DEBUG) {
        print("[info] $message");
    }
}

main() {
    List<String> args = (new Options()).arguments;

    Process f = new Process.start("frogc", args.getRange(0, 1));

    f.onStart = () => info("flogc started");

    f.onExit = (int exitCode) {
        info("frogc finished with $exitCode");

        if(exitCode != 0) exit(exitCode);

        args[0] += ".js";
        Process n = new Process.start("node", args);

        n.onStart = () => info("node started");
        n.onExit  = (int exitCode) => exit(exitCode);

        n.stdin.close();
        n.stdout.onData = () {
            List buffer = n.stdout.read();
            stdout.write(buffer);
        };
        n.stderr.onData = () {
            List buffer = n.stderr.read();
            stderr.write(buffer);
        };
    };

    f.stdin.close();
    f.stdout.onData = () {
        List buffer = f.stdout.read();
        stdout.write(buffer);
    };
    f.stderr.onData = () {
        List buffer = f.stderr.read();
        stderr.write(buffer);
    };
}

