{ stdenv, fetchgit, cmake, servus, pkgconfig, python, pythonPackages, boost }:


let 
	python-env = python.buildEnv.override {
    extraLibs = [ 
				  pythonPackages.pyparsing
				];
 };

in
stdenv.mkDerivation rec {
  name = "zerobuf-${version}";
  version = "0.5-dev201708";

  buildInputs = [ stdenv pkgconfig servus cmake python-env boost ];


  src = fetchgit {
    url = "https://github.com/HBPVIS/ZeroBuf.git";
    rev = "748d6aafde87dfce7ed5297e04527e7dabf59d30";
    sha256 = "1zs5bxb2wrqav9kbyvaqjmkl9r2xvdg4wk4hzdq0bhn9w3sp4z5i";
  };
  
  enableParallelBuilding = false;

  propagatedBuildInputs = [ servus ];

  postInstall = ''
		sed -i 's@!/usr/bin/env python@!${python-env}/bin/python@g' $out/bin/zerobufCxx.py
		chmod a+x $out/bin/zerobufCxx.py
  '';  

  doCheck = true;

  checkPhase = ''
		export LD_LIBRARY_PATH=''${PWD}/lib:''${LD_LIBRARY_PATH}
		ctest -V
		'';

  passthru.python = python-env;

}



