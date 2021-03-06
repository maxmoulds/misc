#!/usr/bin/env bash
_V=2

SRC="/home/max/ffmpeg_sources"
FFMPEG_REPO="http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2"
X265_REPO="hg clone https://bitbucket.org/multicoreware/x265"
X264_REPO="http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2"
AAC_REPO="wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master"
LAME_REPO="http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz"
OPUS_REPO="http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz"
VPX_REPO="http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.5.0.tar.bz2"
# -DHIGH_BIT_DEPTH=ON 

function main() {
#something
export MAKEFLAGS="-j4"
mkdir -p "$SRC"
cd "$SRC"

#get all the files
#wget "$X264_REPO"
#hg clone "$X265_REPO"
#wget "$AAC_REPO"
#wget "$LAME_REPO"
#wget "$OPUS_REPO"
#wget "$VPX_REPO"
wget "$FFMPEG_REPO"


#x264
#tar xjvf last_x264.tar.bz2
#cd x264-snapshot*
##PATH="$HOME/bin:$PATH"
#./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --enable-pic --bit-depth=10
##PATH="$HOME/bin:$PATH" 
#make
#make install
#make distclean
cd ~/ffmpeg_sources && \
  git -C x264 pull 2> /dev/null || git clone --depth 1 http://git.videolan.org/git/x264 && \
  cd x264 && \
  PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --bit-depth=10 --enable-pic --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static && \
  PATH="$HOME/bin:$PATH" make && \
  make install


#x265
cd "$SRC"
cd ~/ffmpeg_sources && \
  if cd x265 2> /dev/null; then hg pull && hg update; else hg clone https://bitbucket.org/multicoreware/x265; fi && \
    cd x265/build/linux && \
    PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DHIGH_BIT_DEPTH=ON -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source && \
    PATH="$HOME/bin:$PATH" make && \
    make install
    make distclean


#$($X265_REPO)
#cd ./x265/build/linux
#PATH="$HOME/bin:$PATH"
#cmake -G "Unix Makefiles" -DHIGH_BIT_DEPTH=ON -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
#make
#make install
#make distclean

#aac
#cd "$SRC"
#$($AAC_REPO)
#tar xzvf fdk-aac.tar.gz
#cd mstorsjo-fdk-aac*
#autoreconf -fiv
#./configure --prefix="$HOME/ffmpeg_build" --disable-shared
#make
#make install
#make distclean
cd ~/ffmpeg_sources && \
  git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
  cd fdk-aac && \
  autoreconf -fiv && \
  ./configure --prefix="$HOME/ffmpeg_build" --disable-shared -fPIC && \
  make && \
  make install


#lame
#cd "$SRC"
#tar xzvf lame-3.99.5.tar.gz
#cd lame-3.99.5
#./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --disable-shared
#make
#make install
#make distclean
cd ~/ffmpeg_sources && \
  wget -O lame-3.100.tar.gz http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz && \
  tar xzvf lame-3.100.tar.gz && \
  cd lame-3.100 && \
  PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm && \
  PATH="$HOME/bin:$PATH" make && \
  make install


#opus
#cd "$SRC"
#tar xzvf opus-1.1.tar.gz
#cd opus-1.1
#./configure --prefix="$HOME/ffmpeg_build" --disable-shared
#make
#make install
#make clean
cd ~/ffmpeg_sources && \
  git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
  cd opus && \
  ./autogen.sh && \
  ./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
  make && \
  make install


#vpx
cd "$SRC"
git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
  cd libvpx && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" -fPIC --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
PATH="$HOME/bin:$PATH" make && \
make install

#FFMPEG
cd "$SRC"
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libxvid \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree
PATH="$HOME/bin:$PATH" make && make install && make clean && hash -r 

cd "$SRC"
}


#COLOR
__RED='\033[0;31m'
__NC='\033[0m'
__YEL='\033[1;33m'
__GRN='\033[0;32m'
__WHT='\033[1;37m'
__BACK_RED='\033[41m'
#END COLOR

#this is the error function. Indicates a problem which no logic
#has been written to handle
function log () {
if [[ $_V -ge 0 ]]; then
  echo -e "${__RED}[ERR]${__NC}  ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO[0]}: $@" >&2
fi
    }
#this is the warn function. Indicates a irregularity that has been either
#ignored or rectified. 
    function logv () {
    if [[ $_V -ge 1 ]]; then
      echo -e "${__YEL}[WARN]${__NC} ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO[0]}: $@" >&2
    fi
  }
#this is a info function. Gives terminal notice to the "user". Intended to be 
#redirected to the same file as warn and err, but is not nearly
#as verbose as ext_log (not even close) think of log as being cheap traces
  function logvv () {
  if [[ $_V -ge 2 ]]; then
    echo -e "${__GRN}[INFO]${__NC} ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO[0]}: $@" >&2
  fi
}
#this is a function that alerts for failure. 
function alert () {
echo -e "${__BACK_RED}${__WHT}[FATAL] ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO[0]}: $@${__NC}" >&2
}
#this is function that writes large amounts of debug output to another 
#logging system. 
function ext_log () {
echo -e "[LOG] ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO[0]}: $@" >&2
}
# the trace function is to be overridden by the debug function supplied by
#the developer.
function trace () {
echo -e "[TRACE] ${BASH_SOURCE##*/}:${FUNCNAME[1]}:${BASH_LINENO[0]}: Currently Unsupported $@" >&2
}
#end
main "$@"
