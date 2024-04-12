#include "Engine.h"

int main () {
    Engine engine;

// temporary vvv
    engine.SimpleTest();

// doesn't do anything yet vvv
    engine.Init();
    engine.Run();
    engine.Cleanup();
    return 0;
}