{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.set-app-icon = pkgs.callPackage (
        { stdenv, writeText }:
        stdenv.mkDerivation {
          pname = "set-app-icon";
          version = "1.0.0";

          src = writeText "set-app-icon.m" /* objective-c */ ''
            #import <Cocoa/Cocoa.h>

            int main(int argc, const char *argv[]) {
              @autoreleasepool {
                if (argc != 4) {
                  NSLog(@"Usage: set-app-icon APP IMAGE STATE");
                  return 1;
                }
                NSString *app = [NSString stringWithUTF8String:argv[1]];
                NSString *imagePath = [NSString stringWithUTF8String:argv[2]];
                NSString *statePath = [NSString stringWithUTF8String:argv[3]];
                NSFileManager *files = NSFileManager.defaultManager;
                if (![files fileExistsAtPath:app]) return 0;

                NSError *error = nil;
                NSDictionary *appAttributes = [files attributesOfItemAtPath:app error:&error];
                NSDictionary *infoAttributes = [files attributesOfItemAtPath:
                  [app stringByAppendingPathComponent:@"Contents/Info.plist"] error:&error];
                if (!appAttributes || !infoAttributes) {
                  NSLog(@"Cannot inspect app: %@", error);
                  return 1;
                }
                NSString *signature = [NSString stringWithFormat:@"%@:%@:%@:%@",
                  appAttributes[NSFileSystemFileNumber],
                  infoAttributes[NSFileSystemFileNumber],
                  infoAttributes[NSFileModificationDate], imagePath];
                NSString *previous = [NSString stringWithContentsOfFile:statePath
                  encoding:NSUTF8StringEncoding error:nil];
                if ([previous isEqualToString:signature]) return 0;

                NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
                if (!image || ![NSWorkspace.sharedWorkspace setIcon:image forFile:app options:0]) {
                  NSLog(@"Cannot set icon on %@", app);
                  return 1;
                }
                if (![files createDirectoryAtPath:[statePath stringByDeletingLastPathComponent]
                  withIntermediateDirectories:YES attributes:nil error:&error] ||
                  ![signature writeToFile:statePath atomically:YES
                  encoding:NSUTF8StringEncoding error:&error]) {
                  NSLog(@"Cannot save icon state: %@", error);
                  return 1;
                }
                return 0;
              }
            }
          '';

          dontUnpack = true;

          buildPhase = /* bash */ ''
            runHook preBuild
            $CC -x objective-c "$src" -framework Cocoa -o set-app-icon
            runHook postBuild
          '';

          installPhase = /* bash */ ''
            runHook preInstall
            install -Dm755 set-app-icon "$out/bin/set-app-icon"
            runHook postInstall
          '';

          meta = {
            mainProgram = "set-app-icon";
            platforms = [ "aarch64-darwin" "x86_64-darwin" ];
          };
        }
      ) { };
    };
}
