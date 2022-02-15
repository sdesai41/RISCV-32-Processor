#include <iostream>
#include <stdio.h>
#include<stdlib.h>
#include <string>
#include<fstream>
#include <sstream>
#include <vector>
using namespace std;


int main(int argc, char* argv[])
{
	/* This is the front end of your project.
	You need to first read the instructions that are stored in a file and load them into an instruction memory.
	*/
	


	std::ofstream outfile("mult_IM.txt");





	if (argc > 1) {
		//cout << "argv[1] = " << argv[1] << endl;
	}
	else {
		//cout << "No file name entered. Exiting...";
		return -1;
	}
	ifstream infile(argv[1]); //open the file
	int i = 0;
	if (infile.is_open() && infile.good()) {
		//cout << "File is now open!\nContains:\n";
		string line = "";
		while (getline(infile, line)) 
		{
			//output lines in format compatible with processor
			{
				outfile << "im[" << to_string(i) << "]= 8'h" << line[8] << line[9] << ";" << endl;
				outfile << "im[" << to_string(i + 1) << "]= 8'h" << line[6] << line[7] << ";" << endl;
				outfile << "im[" << to_string(i+2) << "]= 8'h" << line[4] << line[5] << ";" << endl;
				outfile << "im[" << to_string(i+3) << "]= 8'h" << line[2] << line[3] << ";" << endl;
				cout << line << endl;
			}
			i = i + 4;
			//cout << "bits:"<< bitset<8>(x) << endl;

			// << "copying instMem:" << instMem[i] << endl;
		}

	}
	else {
		cout << "Failed to open file..";
	}
	outfile.close();
	return 0;
}