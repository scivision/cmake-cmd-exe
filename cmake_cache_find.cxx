#include <iostream>
#include <filesystem>
#include <chrono>

namespace fs = std::filesystem;

int main(int argc, char* argv[])
{
    fs::path home;
    if (argc == 1)
        home = std::getenv(
#ifdef _WIN32
            "USERPROFILE"
#else
            "HOME"
#endif
        );
    else
        home = argv[1];

    std::string search_for;
    if (argc > 2)
        search_for = argv[2];
    else
        search_for = "CMakeCache.txt";

    std::cout << "Searching for " << search_for << " under " << home << '\n';
    int count = 0;

    auto time_start = std::chrono::steady_clock::now();

    for (auto const& dir_entry : fs::recursive_directory_iterator(home))
    {
        if (dir_entry.is_regular_file()){
            if(dir_entry.path().filename() == search_for){
                std::cout << dir_entry << '\n';
                // or inject our bad cmd.exe here
                count++;
            }
        }
    }

    auto time_finish = std::chrono::steady_clock::now();
    std::chrono::duration<double> time_elapsed = time_finish - time_start;

    std::cout << "Found " << count << " " << search_for << " files in " << time_elapsed.count() << " seconds.\n";

    return 0;
}
