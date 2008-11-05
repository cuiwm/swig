/* -----------------------------------------------------------------------------
 * See the LICENSE file for information on copyright, usage and redistribution
 * of SWIG, and the README file for authors - http://www.swig.org/release.html.
 *
 * std_string.swg
 *
 * COM typemaps for std::string and const std::string&
 * ----------------------------------------------------------------------------- */

%{
#include <string>
%}

namespace std {

%naturalvar string;
class string;

%typemap(ctype) string, const string & "WCHAR *"
%typemap(comtype) string, const string & "BSTR"

%typemap(in) string {
  if ($input) {
    int SWIG_len = WideCharToMultiByte(CP_ACP, 0, $input, -1, 0, 0, 0, 0);
    char *$1_pstr = (char *) malloc(SWIG_len);
    WideCharToMultiByte(CP_ACP, 0, $input, -1, $1_pstr, SWIG_len, 0, 0);
    $1.assign($1_pstr);
    free($1_pstr);
  }
}

%typemap(in) const string & ($*1_ltype temp) {
  if ($input) {
    int SWIG_len = WideCharToMultiByte(CP_ACP, 0, $input, -1, 0, 0, 0, 0);
    char *$1_pstr = (char *) malloc(SWIG_len);
    WideCharToMultiByte(CP_ACP, 0, $input, -1, $1_pstr, SWIG_len, 0, 0);
    temp.assign($1_pstr);
    free($1_pstr);
  }

  $1 = &temp;
}

%typemap(out) string %{
  {
    int SWIG_len = MultiByteToWideChar(CP_ACP, 0, $1.c_str(), -1, 0, 0);
    WCHAR *SWIG_res = (WCHAR *) CoTaskMemAlloc((SWIG_len + 2) * sizeof(WCHAR));
    /* First 4 bytes contain length in bytes */
    *((unsigned int *) SWIG_res) = (unsigned int) (SWIG_len - 1) * sizeof(WCHAR);
    MultiByteToWideChar(CP_ACP, 0, $1.c_str(), -1, SWIG_res + 2, SWIG_len);
    $result = SWIG_res + 2;
  }
%}

%typemap(out) const string & %{
  {
    int SWIG_len = MultiByteToWideChar(CP_ACP, 0, (*$1).c_str(), -1, 0, 0);
    WCHAR *SWIG_res = (WCHAR *) CoTaskMemAlloc((SWIG_len + 2) * sizeof(WCHAR));
    /* First 4 bytes contain length in bytes */
    *((unsigned int *) SWIG_res) = (unsigned int) (SWIG_len - 1) * sizeof(WCHAR);
    MultiByteToWideChar(CP_ACP, 0, (*$1).c_str(), -1, SWIG_res + 2, SWIG_len);
    $result = SWIG_res + 2;
  }
%}

}
