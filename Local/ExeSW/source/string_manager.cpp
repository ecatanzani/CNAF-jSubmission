#include "MyHead.h"

void loop_on_list(char *list,std::vector<std::string> &list_vector) {
    std::ifstream input_file(list);
    if(!input_file.is_open()) {
        std::cerr << "\nERROR 100! File not open. The path is:\n" <<list<< "\n\n";
        exit(100);
    }
    std::string input_string((std::istreambuf_iterator< char >(input_file)), (std::istreambuf_iterator< char >()));
    std::string tmp_str;
    input_file.close();
    std::istringstream input_stream(input_string);
    while(input_stream>>tmp_str)
        //for (string::iterator it=input_stream.begin();it!=input_stream.end();++it)
        list_vector.push_back(tmp_str);
    
}

void get_name(std::string all_path,std::string &f_name) {
    std::size_t found=all_path.find_last_of("/");
    f_name=all_path.substr(found+1);
    found=f_name.find_last_of("_");
    f_name=f_name.substr(0,found);
    f_name.append(".root");
}

