
import 'package:flutter/material.dart';

class OnboardingProvider with ChangeNotifier{
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void nextPage(){
    _currentPage++;
    notifyListeners();
  }
  void setCurrentPage(int page){
    _currentPage = page;
    notifyListeners();
  }
}