////////////////////////////// C++ software to create a list of files contained in a certain input directory
/* Arguments to provide:

argv[1] --> _INDIRECTORY_ absolute path
argv[2] --> _OUTDIRECTORY_ absolute path
argv[3] --> _LISTNAME_ (eithout extension, it'll be added automatically)
argv[4] (optional) --> number of files to list (if empy all files will be listed)
 
 Enjoy using !!! ;-)

*/
 
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>
#include <vector>
#include <string>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <cstdlib>

using namespace std;

void explore_dir(string input_dir, vector<string> &files);
void explore_dir_wl(string input_dir,vector<string> &files,unsigned int n_files);

int main(int argc, char* argv[]) {

  if(argc<4) {
    cout<<"\n\n ERROR: insert [1] _INdiretcory_ [2] _OUTlist_ ABSOLUTE paths [3] _listNAME_ and (optional) [4] _#out_FILES_ \n\n";
    exit(-1);
  }
 
  string input_dir=argv[1],path_list=argv[2],l_name=argv[3]; 
  vector<string> files = vector<string>();
  l_name.append(".txt",4);
  path_list.append("/",1);
  path_list.append(l_name);
  
  /*
    OBTAINING CURRENT WORKDIR:

    char cwd[1024];
    if (getcwd(cwd, sizeof(cwd)) != NULL)
        fprintf(stdout, "Current working dir: %s\n", cwd);
    else
        perror("getcwd() error");

   */

  ofstream mylist (path_list.c_str());
  if(!mylist.is_open()) {
    cout<<"\n\n ERROR: error writing list ! \n\n";
    exit(-1);
  }
  
  if(argv[4]==NULL)
    explore_dir(input_dir,files);
  else
    explore_dir_wl(input_dir,files,(unsigned)atoi(argv[4]));
  
  for(unsigned int v_idx=0;v_idx<files.size();v_idx++) {
    mylist<<files[v_idx]<<endl;
  }
  mylist.close();
  
  return 0;
}

void explore_dir(string input_dir, vector<string> &files) {
  DIR *dp;
  struct dirent *dirp;
  string tmp_element,deny_elm=".";


  if((dp=opendir(input_dir.c_str())) == NULL)
    cout << "ERROR (" << errno << ") opening " << input_dir << endl;
  while ((dirp = readdir(dp)) != NULL) {
    //if(strncmp(dirp->d_name, deny_string, strlen(deny_string)))                                  
    tmp_element=string(dirp->d_name);
    if(tmp_element.rfind(".",0)) {
      tmp_element.insert(0,input_dir);
      tmp_element.insert(input_dir.length(),"/");
      files.push_back(tmp_element);
    }
    else
      continue;
  }
  closedir(dp);
}

void explore_dir_wl(string input_dir,vector<string> &files,unsigned int n_files) {
  DIR *dp;
  struct dirent *dirp;
  string tmp_element,deny_elm=".";
  unsigned int fcounter=0;

  if((dp=opendir(input_dir.c_str())) == NULL)
    cout << "ERROR (" << errno << ") opening " << input_dir << endl;
  while ((dirp = readdir(dp)) != NULL && fcounter<n_files) {
    //if(strncmp(dirp->d_name, deny_string, strlen(deny_string)))
    tmp_element=string(dirp->d_name);
    if(tmp_element.rfind(".",0)) {
      tmp_element.insert(0,input_dir);
      tmp_element.insert(input_dir.length(),"/");
      files.push_back(tmp_element);
      fcounter++;  //founter is updated here to avoid counts of hidden files, starting with . !!!
    }
    else
      continue;
  }
  closedir(dp);
}
