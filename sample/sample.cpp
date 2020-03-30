#include "ftplib.h"
#include <iostream>

int main(void)
{
	ftplib *ftp = new ftplib();
	ftp->Connect("192.168.0.124:21");
	ftp->Login("rvbust", "rvbust");
	// ftp->Dir(NULL, "/pub/linux/apache");
	char buf[100];
	ftp->Pwd(buf, 100);
	std::cout << buf << std::endl;
	int ret = ftp->Put("/home/rvbust/Rvbust/Sources/ftplibpp/sample/Readme.md", "Readme1.md", ftplib::transfermode::ascii);
	std::cout << ret << std::endl;
	std::cout << ftp->LastResponse() << std::endl;
	ret = ftp->Get("./Readme_copy.md", "Readme1.md", ftplib::transfermode::image);
	std::cout << ret << std::endl;
	std::cout << ftp->LastResponse() << std::endl;
	ftp->Quit();
	return 0;
}
