// dist_func.cpp

// header files to include
#include <Rcpp.h>

// preprocessor replacements 
#define e_r 6378137.0
#define m_pi 3.141592653589793238462643383280

// use Rcpp namespace to avoid Rcpp::<...> repetition
using namespace Rcpp;

// NOTE ----------------------------------
// The following come from Rcpp namespace:
//
// CharacterVector
// Named
// NumericVector
// NumericMatrix
// DataFrame
// ---------------------------------------

// convert degrees to radians
// [[Rcpp::export]]
double deg_to_rad_rcpp(double degree) {
  return(degree * m_pi / 180.0);
}

// compute Haversine distance between two points
// [[Rcpp::export]]
double dist_haversine_rcpp(double xlon,
			   double xlat,
			   double ylon,
			   double ylat) {

  // return 0 if same point
  if (xlon == ylon && xlat == xlon) return 0.0;

  // convert degrees to radians
  xlon = deg_to_rad_rcpp(xlon);
  xlat = deg_to_rad_rcpp(xlat);
  ylon = deg_to_rad_rcpp(ylon);
  ylat = deg_to_rad_rcpp(ylat);

  // haversine distance formula
  double d1 = sin((ylat - xlat) / 2.0);
  double d2 = sin((ylon - xlon) / 2.0);
  return 2.0 * e_r * asin(sqrt(d1*d1 + cos(xlat) * cos(ylat) * d2*d2));
}

// compute many to many distances and return matrix
// [[Rcpp::export]]
NumericMatrix dist_mtom_rcpp(NumericVector xlon,
			     NumericVector xlat,
			     NumericVector ylon,
			     NumericVector ylat,
			     CharacterVector x_names,
			     CharacterVector y_names) {

  // init output matrix (x X y)
  int n = xlon.size();
  int k = ylon.size();
  NumericMatrix distmat(n,k);

  // double loop through each set of points to get all combinations
  for(int i = 0; i < n; i++) {
    for(int j = 0; j < k; j++) {
      distmat(i,j) = dist_haversine_rcpp(xlon[i],xlat[i],ylon[j],ylat[j]);
    }
  }
  // add row and column names
  rownames(distmat) = x_names;
  colnames(distmat) = y_names;
  return distmat;
}

// compute and return minimum distance along with name
// [[Rcpp::export]]
DataFrame dist_min_rcpp(NumericVector xlon,
			NumericVector xlat,
			NumericVector ylon,
			NumericVector ylat,
			CharacterVector x_names,
			CharacterVector y_names) {

  // init output matrix (x X 3)
  int n = xlon.size();
  int k = ylon.size();
  CharacterVector minvec_name(n);
  NumericVector minvec_meter(n);
  NumericVector tmp(k);
  
  // loop through each set of starting points
  for(int i = 0; i < n; i++) {
    for(int j = 0; j < k; j++) {
      tmp[j] = dist_haversine_rcpp(xlon[i],xlat[i],ylon[j],ylat[j]);
    }
    // add to output matrix
    minvec_name[i] = y_names[which_min(tmp)];
    minvec_meter[i] = min(tmp);
  }
  
  // return created data frame
  return DataFrame::create(Named("fips11") = x_names,
			   Named("unitid") = minvec_name,
			   Named("meters") = minvec_meter,
			   _["stringsAsFactors"] = false);
}

