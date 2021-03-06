{ stdenv
, boost
, fetchgit
, cmake
, servus
, pkgconfig
, doxygen 
, legacyVersion ? false
}:


let
        legacy-info = {
                version = "2.16.0-legacy";
                rev = "1a96478";
                sha256 = "0igsmr741bfwzq0x5x5li53vwh33233bciryrn2fnkigjj0y9jff";
        };

        last-info = {
                version = "1.16.0-dev201708";
                rev = "80c14e04666aeb64eb69c605663b3065252339c5";
                sha256 = "0y4ygxrrvil3p34wppiqc08q3abpjk83fcz2pmsqrcz61x4vvmji";
        };

        lunchbox-info = if (legacyVersion) then legacy-info else last-info;

in
stdenv.mkDerivation rec {
  name = "lunchbox";
  version = lunchbox-info.version;
  buildInputs = [ stdenv boost pkgconfig servus cmake doxygen];

  src = fetchgit {
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = lunchbox-info.rev;
    sha256 = lunchbox-info.sha256;
  };
 

  cmakeFlags = [ "-DCOMMON_DISABLE_WERROR=TRUE" ];


  propagatedBuildInputs = [ boost servus ];


  enableParallelBuilding = true;

  doCheck = true;

  checkPhase = ''
	export LD_LIBRARY_PATH=''${PWD}/lib/:''${LD_LIBRARY_PATH}
	# disable perf -> too much time and memory
	# disable thread -> will fail when executed on machine with low resource
	ctest -V -E "(perf|Thread|thread)"
  '';
  
}



