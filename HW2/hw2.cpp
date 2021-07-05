#include <iostream>
#define MAX_SIZE 100

using namespace std;

int CheckSumPossibility(int num, int* arr, int arraySize);
int main()
{
	int arraySize;
	int arr[MAX_SIZE];
	int num;
	int returnVal;
	
	cin >> arraySize;
	cin >> num;
	
	for (int i = 0; i < arraySize; ++i) {
		cin >> arr[i];
	}
	
	returnVal = CheckSumPossibility(num, arr, arraySize);
	
	if(returnVal == 1) {
		cout << "Possible!" << endl;
	} else {
		cout << "Not Possible!" << endl;
	}
	
	return 0;
}

int CheckSumPossibility(int num, int* arr, int arraySize) {
	int total = 0;
	if (num == 0) {
		return 1;
	}
	if (arraySize == 0) {
		return 0;
	}
	for (int i = arraySize - 1; i >= 0; i--) {
		total += arr[i];
	}
	if (num > total) {
		return 0;
	}
	if (num < arr[arraySize - 1]) {
		return CheckSumPossibility(num, arr, arraySize - 1);
	}
	
	int retVal1 = CheckSumPossibility(num - arr[arraySize - 1], arr, arraySize - 1);
	int retVal2 = CheckSumPossibility(num, arr, arraySize - 1);
	
	return retVal1 || retVal2;
		
}
