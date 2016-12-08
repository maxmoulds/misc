#!/usr/bin/env bash
#DEFAULT LEVEL OF VERBOSITY#
_V=2
####### WELCOME TO THE ULTIMATE-ISH CHYMERA RUN SCRIPT(S)
# WORKS WITH point (chymera-uo)
# WORKS WITH resolved (chymera-whit)
# SEE support section(s) listed below to add support for 
# new model types or change existing behavior.
# UNLESS NOTED, most sections will not need to be changed
# from model to model and 
## NO SECTIONS, I repeat NO CHANGES SHOULD BE MADE
# from run to run of the same model type. 
# Those changes are to be made in the "input" file 
# for this script
#####
#  USAGE  #
# I test with the command 
# $ bash ./[this script.sh] -i [input.txt]
# # so an example would be...
# $ bash ./chymera-run.sh -i pM1m3k256j256.txt 
#
# SECTIONS
# # INCLUDES - these are files required for the models to run
# # VARIABLES - these are commandline switches/info.txt vars
# # # used to tweak the 'run'
# # SCRIPTS - abstracted logic, for simplicity. add function here
# # # then call in the main. 

##### MAIN LOGIC #### where the meat is. 
#this var is weird. i need a way to get back home. work out later.
_SRC_DIR=.
#src-log.sh is not supported atm. 
#source $_SRC_DIR/src-log.sh

#NOTE ANY CALLS TO FUNCTIONS DEFINED IN THIS SCRIPT outside 
# of the main loop will not function as one would expect. 
# jail me from here on out. 

function main() {
# 1. Set up log / parse commandline _CHYMERA_input-parse
# 2. Check location/find bin - {all files} _CHYMERA_md5-sum
# 3. Determine point/resolved - start/restart
# 4. Read/Write Info
#USE LOG as a general messaging system to the user. 
#useful in interactive mode, and as a way of seeing
#in process info (see attachment, terminal catch/redirect)
log "Welcome to the CHYMERA run script written by Max Moulds"
#USE LOGV to send non-important user info. 
#USE LOGVV to send even less important user info
#USE LOGVVV to send non-sensical jibberish meant to entertain
#basic environment sanity check. 
logv "Today is a wonderful day because it is $(date). And the sun is shining somewhere"
logv "You are using this program on a $(uname -a) machine"
logvv "$(fortune)"
# End basic sanity - starting serious work
#parse commandline first
input_parse "$@"
#use alert to send important program related messages that may need to 
# handled by the/a script. 
alert "You are awesome, and passed me $# arguments, and   info files"
logvv "here are some files to hash from $RUN_DIR"
####TEMPORARY SUPPORT
#__POINT_LIBS="bin analysis analysis-uo eos fluid headers legacy particles patch pot radhydro"
__md5_files=$(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/analysis/* | egrep -v '^d' | head -c-1 | wc -l)
logvv "after analysis __md5_sum is $__md5_files"
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/bin/* | egrep -v '^d' | head -c-1 | wc -l)))
logvv "after bin and analysis __md5_sum is $__md5_files"
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/analysis-uo/* | egrep -v '^d' | head -c-1 | wc -l)))
logvv "after bin analysis analysis-uo__md5_sum is $__md5_files"
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/eos/* | egrep -v '^d' | head -c-1 | wc -l)))
logvv "after bin and analysis analysis-uo eos __md5_sum is $__md5_files"
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/fluid/* | egrep -v '^d' | head -c-1 | wc -l)))
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/fluid/old/* | egrep -v '^d' | head -c-1 | wc -l)))
logvv "after bin and analysis analysis-uo eos fluid __md5_sum is $__md5_files"
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/headers/* | egrep -v '^d' | head -c-1 | wc -l)))
logvv "after bin and analysis analysis-uo eos fluid headers  __md5_sum is $__md5_files"
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/legacy/* | egrep -v '^d' | head -c-1 | wc -l)))
logvv "after bin and analysis analysis-uo eos fluid headers legacy __md5_sum is $__md5_files"
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/particles/* | egrep -v '^d' | head -c-1 | wc -l)))
logvv "after bin and analysis analysis-uo eos fluid headers legacy particles __md5_sum is $__md5_files"
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/patch/* | egrep -v '^d' | head -c-1 | wc -l)))
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/patch/patch_particle_should_be_obsolete/* | egrep -v '^d' | head -c-1 | wc -l)))
logvv "after bin and analysis analysis-uo eos fluid headers legacy particles patch __md5_sum is $__md5_files"
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/pot/* | egrep -v '^d' | head -c-1 | wc -l)))
logvv "after bin and analysis analysis-uo eos fluid headers legacy particles patch pot __md5_sum is $__md5_files"
__md5_files=$(($__md5_files + $(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./point/radhydro/* | egrep -v '^d' | head -c-1 | wc -l)))
logvv "after bin and analysis analysis-uo eos fluid headeres legacy particles patch pot radhydro __md5_sum is $__md5_files"
md5_sum_check $RUN_DIR
md5_sum_gen $RUN_DIR
md5_sum_check $RUN_DIR
#use ext_log only if you have set up support for this. 
#and example of this is to log the progress of the run externally by another script. 
#see run-log.sh as a call .
#ext_log "This would be output to a log sys specified"
#TRACE is not to be used yet. I was just getting way ahead of myself. 
# trace "- someday"

#do some input based logic
#are we in a model directory? every chymera model should have a bin directory. 
#see INCLUDES SECTION for a list of what I expect. 

}

#### END MAIN loop ###

#### VARIABLES SECTION ####
## !! must come 2nd after main logic, but before scripts
#COLOR
__RED='\033[0;31m'
__NC='\033[0m'
__YEL='\033[1;33m'
__GRN='\033[0;32m'
__WHT='\033[1;37m'
__BACK_RED='\033[41m'
#__md5_files=
#END COLOR

__POINT_LIBS="bin analysis analysis-uo eos fluid headers legacy particles patch pot radhydro" 
__RESOLVED_LIBS="bin"
#### ! END VARIABLES SECTION ####

#### INCLUDES SECTION ####
# this section can float anywhere and even be external. 
# it has to exist though. 
#BIN - POINT
point_bin_eos_mod=fb51d6d0fd4c3a246e8262e65e1941d8
point_bin_Makefile=51085ee3a3e11c6a3b0136cd89f7a9e5
point_bin_Makefile_columbia=51df27c8e0bb7ff54cf5254afb80f06c
point_bin_Makefile_debug=cc9f694ec7a4d3f1d662100088f27992
point_bin_Makefile_DEFS=da704f27e861b3f25cba0822259c3681
point_bin_Makefile_endeavor=5eea617c475399f3d6cbc9004406d3b4
point_bin_Makefile_gcc=16f7b4e6705e808cc0d657017b2f1b54
point_bin_Makefile_intel=03ad220064829ddedc02cde04a897649
point_bin_Makefile_pgf95=8ad0b6a1babd1a06ab683974b328ac87
point_bin_particle_mod=4377c2260ed309faf8c2877979599b42
point_bin_utilities_mod=57cd65b127ed4dfc7c708e8a62e7bffa
#ANALYSIS - POINT
point_analysis_chympart2_f90=0daad1ed78865401b16c205ec3c4d83a
point_analysis_chympart_f90=4af60343102da1aaa689463860076263
point_analysis_dustprof_f90=0f9356cf2b1ad6a9c877289ee7bff773
point_analysis_dustsig_f90=bdd6d0cddc927d185b33edc322b8294c
point_analysis_find_clump_py=8c834ca62a1557e83152c0d80b10df29
point_analysis_gastodust_f90=2625feabd86b25c984ac63a466e4a9a4
point_analysis_inject_az_f90=a119e232d0c825de5d2358df6ef697e0
point_analysis_inject_rz_f90=29c2d5ee71a2da090be2f5bbe2a874fe
point_analysis_make_disk_model_py=99d8396c7cba6a0dc4a0258658f53162
point_analysis_makeimage_py=6316d965c751ad877d339a21ce9c316a
point_analysis_makemerid_sh=fe85c26fdfc50542ee54bade94fb2972
point_analysis_makesig_sh=6821ec6c39bdd56e301662f85858df2f
point_analysis_maxClump_f90=51f569f423a7ec5571b4f2fc03534f8f
point_analysis_mdot_image_py=795ca59cc90de5fd76a07985eb60edc1
point_analysis_mdot_py=9f87511eea872216cf173e7b06dc768f
point_analysis_meridional_f90=518d5683a0cbed98de2087f67525ec45
point_analysis_midplot=9ea3ae6e6d80d3699a386439e1dd3040
point_analysis_midplot_f90=fbc050264721b0e3a88261511aec722e
point_analysis_overden_f90=05ee58e91f6598bddcb3fdf06e49a478
point_analysis_phase_f90=35f6025fb914e6bbc5f47149b3271b7d
point_analysis_phiplot_f90=5332d160e606b07fb063ac7cb39676ce
point_analysis_plotpart_f90=265b4a98dda0560e1e54191aa6212239
point_analysis_plotpart_sh=3b9d08defe4a2add4f67f891f474f073
point_analysis_q_init=aee00d2dbfbf74080013517e2f79cb06
point_analysis_qlocal_py=08949c103089edfd48c92af622cadc97
point_analysis_qprof_var=4c7a42a31f8c813db8dc450863da90fa
point_analysis_qprof_var_f90=a4bb8a17db730001ee46b4031ed622d1
point_analysis_script_test=fc8acee1098e62573814d570c6e808cf
point_analysis_sigplot_f90=cc8f6eb7277f0757008c3da11ea6f0ba
point_analysis_test_rho_png=bebb26906927f4f42ce435a16e54d00b
point_analysis_test_tk_png=43ec8f70bbc32bbaacf137e317d59a77
point_analysis_truelove2_f90=3bbad61c955735fd43797189b6796adb
point_analysis_truelove_f90=0ed31cc83128b7b160e73c4482e5ea0b
point_analysis_vplot_cyl_f90=8ad7eeae20ffdd33450feda51f1e1044
point_analysis_vplot_f90=e4b2c603cba42344c61b18e9c95da1c3
#END POINT - ANALYSIS
# POINT - analysis-uo
point_analysis_uo_anal_dat=f4e5e1decd3376b622bec5d0f4914bd0
point_analysis_uo_a_out=43979b633e70d437dc815f39e7619bca
point_analysis_uo_draw=2aaff1ccf59a812c18ed8feb698ee10b
point_analysis_uo_draw128=c7d48aa76bc1b1e6a43243f760787672
point_analysis_uo_drawcontour=113f113789afc087838ddc5c1816c100
point_analysis_uo_drawcontour_f=412b16f788ba7123f4f277e98ed03aea
point_analysis_uo_eigen128=6cc058dad806049fce28e9faf9011efe
point_analysis_uo_eigen1_f=00909e769add6732dfb2da5f1f68aac1
point_analysis_uo_eigen_f=d84ddb749c2b4ae1f8c6b798ed6889b3
point_analysis_uo_flat_f=429d651e1b531b6524af1e852576d584
point_analysis_uo_param_h=8255562d42be913e255225ef6aac36c5
point_analysis_uo_plotcontour=e1567719f2de66f09c117569814e8ffc
point_analysis_uo_ploteigen=d847469fce784b3dd802f1779a6b4198
point_analysis_uo_poly=81db8c2888323648f578832e35fc6b36
point_analysis_uo_polyout=21793f8927b03f05acb55842a4e5d2b0
point_analysis_uo_resolved_amplitude_ps=110cf8d0e0554f2e6950c56bb08e0c7d
point_analysis_uo_sigplot=80332cae15453459ac04eb032f3356fc
point_analysis_uo_star_disk_in=83181eeec7c0103903f366334bd3db9d
# END POINT - analysis-uo

# POINT - eos
point_eos_eos_f90=a43ad6ef98361cd64cdd84cc1eabd25a
point_eos_initengtable_f_obsolete=f11e4e2b7d0bc677fd9ebbda94153f0c
point_eos_state_f=b04f083fc3555366aadcaef2e3c5ddfe
point_eos_state_f_obsolete=e200706ff298443628f08e590ca130c1
# END POINT - eos

# POINT - fluid 
point_fluid_fluid_advance_F=3f2275daa0c69585f105a4f12a716779
point_fluid_fluid_interp_F=c19b8248d929d1590c5bd4a726aedab7
point_fluid_fluid_mod_F=48f37858b00b023e3804de5afb6c2e77
point_fluid_fluid_restart_F=8e4833492f0c4f45ba9d34a2f25d5389
point_fluid_fluid_setup_F=841e43991ad77d12287422d91e46d2bc
point_fluid_fluid_start_F=f02c0d3fff49f0f67bd729f2484f987b
point_fluid_fluid_writeout_F=b51f102ec539f1b331aee0452818e004
point_fluid_interp_1alloc_c=1144c0ea8c2a11403180f7f2bb67f679
point_fluid_interp_c=00e41e8d8678f37b191fe59ca0622eaa
point_fluid_interp_project_F=2deafd2d26c61e0842027247c489ba16
point_fluid_old_fluid_advance_F=8a0ad68fe51034a073e3bd3a62703e35
point_fluid_old_fluid_interp_F=5e0f17147561f14c321e6d96834686fb
point_fluid_old_fluid_mod_F=a6e67d6c9aad086b74056c8f6ac848a5
point_fluid_old_fluid_restart_F=8e4833492f0c4f45ba9d34a2f25d5389
point_fluid_old_fluid_setup_F=b1b402130371675820edeb6405d9e553
point_fluid_old_fluid_start_F=59d1562f3ad9e53db9a3c48df56f7548
point_fluid_old_fluid_writeout_F=b51f102ec539f1b331aee0452818e004
point_fluid_old_interp_1alloc_c=1144c0ea8c2a11403180f7f2bb67f679
point_fluid_old_interp_c=00e41e8d8678f37b191fe59ca0622eaa
point_fluid_old_interp_project_F=2deafd2d26c61e0842027247c489ba16
# END POINT - fluid

# POINT - headers 
point_headers_globals_h=5aff9c083ee7ced1d79627997384594f
point_headers_globals_h_old=c9e3215b08fb03c9924b7b9ef0370b99
point_headers_hydroparam_h=c581573275d31ade83296833d7916b78
point_headers_readme_txt=5a5cbc1a6ecb46142c90f9f58cc83fcf
point_headers_units_h=99d764c96e80e60e90e5d5b1eab6ea96
# END POINT - headers

# POINT - legacy 
point_legacy_opas_f=e62fc84d2f41c129b0084a78f8acb538
point_legacy_pmm_dat=d3374dd8157eff96fe491cdee6be488f
point_legacy_README=1fdcecc38319331a94c9e5d5a3fc9cb1
# END POINT - legacy 

# POINT - particles
point_particles_particle_module_f=3936d555e9a28452364c3753a9cf38b4
point_particles_particle_module_f90_obsolete=707d1e6aa9f75f88e170d0a5a521d289
# END POINT - partcles

# POINT - patch 
point_patch_ExternalRoutines_f=5cc726d5664c77ee012765a2d47578b4
point_patch_passive_f=4dfce8e21a0c8a7d11ce0fe620c28758
point_patch_patch_particle_should_be_obsolete_3dhyd_main_f=a8aadb2490eb360d6206872ff817e6e9
point_patch_patch_particle_should_be_obsolete_boundary_f=6cb64ea2cf6929b03ad992571295a0dc
point_patch_patch_particle_should_be_obsolete_ExternalPot_f=c97c01d6a18b018bddbfce56260b4fc7
point_patch_patch_particle_should_be_obsolete_ExternalRoutines_f=36e593f23588315d3a90a16e08065802
point_patch_patch_particle_should_be_obsolete_flux_f=4e12e22c8ae8df9b9cea1776d584d7c3
point_patch_patch_particle_should_be_obsolete_housekeeping_f=267347931ee45ae1aac4b5df72385bd3
point_patch_patch_particle_should_be_obsolete_hybrid_f=9d9333ebf2b09fae961cc83b0205e5bd
point_patch_patch_particle_should_be_obsolete_io_f=d4970dcb384fdf45f1b0254c5e7c537f
point_patch_patch_particle_should_be_obsolete_io_f_full=431d96cdbb15383734272ef81e566bb8
point_patch_patch_particle_should_be_obsolete_misc_f=2b3abbe0e428e7b9de16f136af9a2283
point_patch_patch_particle_should_be_obsolete_misc_f_save=fe33d177ef422bd7e72b7259a93301a4
point_patch_patch_particle_should_be_obsolete_particle_module_cart_f=e4467af0d70731046c1c5fe1abcf58aa
point_patch_patch_particle_should_be_obsolete_particle_module_f=3936d555e9a28452364c3753a9cf38b4
point_patch_patch_particle_should_be_obsolete_particle_module_f_full=9f02b116b6b257c3d00f00fb7c3d81ab
point_patch_patch_particle_should_be_obsolete_particle_module_f_jn=54613ba54a5edd359067dc1b62f19140
point_patch_patch_particle_should_be_obsolete_particle_module_fomp=29aced9462e65ce5316986be5aff07fd
point_patch_patch_particle_should_be_obsolete_particle_module_f_omp=4a2c1f1485444e9c37701dfb1dc81c19
point_patch_patch_particle_should_be_obsolete_particle_module_f_save=d9cff2f93f4db171aea70ea49aa2f5e7
point_patch_patch_particle_should_be_obsolete_particle_module_f_static=9b07ecc8999d43166d13439851f404bc
point_patch_patch_particle_should_be_obsolete_particle_module_f_working=9b9b68f40f55610a3304fbadd99e5987
point_patch_patch_particle_should_be_obsolete_passive_f=4dfce8e21a0c8a7d11ce0fe620c28758
point_patch_patch_particle_should_be_obsolete_pot3_f=5a8c12aecd9a11e1df6dd534bd6aae19
point_patch_patch_particle_should_be_obsolete_RadTran_f=d76269610b0752687d6839e4c3b463cd
point_patch_patch_particle_should_be_obsolete_RadTran_f_save=19ac98e7e2578d2c253bf0328e9e6e93
point_patch_patch_particle_should_be_obsolete_README=d92dbbd89c16456d982a8261f88b780c
point_patch_patch_particle_should_be_obsolete_source_f=06112386ea6de56b16c9d1faa5ece852
point_patch_patch_particle_should_be_obsolete_state_f=dab6cb09447c8de3dc936c173e68822f
point_patch_patch_particle_should_be_obsolete_tcart=d41d8cd98f00b204e9800998ecf8427e
point_patch_patch_particle_should_be_obsolete_wiggle_F=3a670ab7e2d6fc7736a2f3cee99a7d19
# END POINT - patch 

# POINT - pot 
point_pot_blktri_f=37c64ebb04c79b3efab3012833a51c9f
point_pot_boundary_f=b8011bd3654986bbda96d248769f0f5e
point_pot_ExternalPot_f=78dfc658b081e0017bdb8dd41732d7ad
point_pot_ExternalPot_original2_f=24960cd570b2139838e5b187fe941369
point_pot_ExternalPot_original_f=c96ca487b47283125ab8af152390541b
point_pot_fft_f=c222dbbedd23e49b7123e30ab5b23896
point_pot_pot3_f=99a2a6364eb308abd792bac90ad956a3
point_pot_wiggle_F=d8b54369af5b9827c5ae85cebd9e6b91
# END POINT - pot

# POINT - radhydro
point_radhydro_3dhyd_main_diff=a95acac062262a291c4d4df2060ade31
point_radhydro_3dhyd_main_f=6bacc7cdff57d0bb1b1e253eca3c4948
point_radhydro_avisc_f=dc9381a6f80d21e48ef7b04ac1e27c97
point_radhydro_CoolingPrescriptions_f=320d26fee1f5d6e397456bfdea8ac1e0
point_radhydro_diff_txt=4f2e2aa921088cf73af79193a58452f2
point_radhydro_ExternalRoutines_f=5cc726d5664c77ee012765a2d47578b4
point_radhydro_flux_f=4e12e22c8ae8df9b9cea1776d584d7c3
point_radhydro_housekeeping_f=a2e796739f3223115cbea24fd1da7da0
point_radhydro_hybrid_f=da41f5e1ee85c64225910f156110a5a0
point_radhydro_hybrid_old_nosubcycle_f=fa95962c7e3e2f0cef92f953ebe1e1bc
point_radhydro_io_diff=dc5c0e9d5a77946a95b116d244a7d3f4
point_radhydro_io_f=5c417758c92c34b0d15ce365c61ebb84
point_radhydro_misc_f=01ff495b17069e2d31cb3d6f0b27f32f
point_radhydro_orig_3dhyd_main_f=ba1d87fe250fb3c7a818f87edad3dc33
point_radhydro_passive_f=4dfce8e21a0c8a7d11ce0fe620c28758
point_radhydro_rad_f=af47b3fc0948124dd59f1df9bfe4943e
point_radhydro_RadTran_f=c12a00b9e3c01cdfaba32af0e730b69f
point_radhydro_source_f=f82010b8dab1f97ef97a37435d2b4e3c
point_radhydro_w_3dhyd_main_f=edd36566a6c465d09707a0fed4459edc
point_radhydro_w_io_f=e7b088125884bfffdfcce5929a707a57
# END POINT - radhydro 

##END POINT#####

#BIN - RES

#END BIN - RES

#### SCRIPTS SECTION ######

## RERUN save logic (formerly 'movit')

## ! END RERUN ##

## LOGGING LOG FUNCTIONS ##

#this is the error function. Indicates a problem which no logic
#has been written to handle
function log () {
if [[ $_V -ge 0 ]]; then
  echo -e "${__RED}[ERR]${__NC}  ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
fi
    }
#this is the warn function. Indicates a irregularity that has been either
#ignored or rectified. 
    function logv () {
    if [[ $_V -ge 1 ]]; then
      echo -e "${__YEL}[WARN]${__NC} ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
    fi
  }
#this is a info function. Gives terminal notice to the "user". Intended to be 
#redirected to the same file as warn and err, but is not nearly
#as verbose as ext_log (not even close) think of log as being cheap traces
  function logvv () {
  if [[ $_V -ge 2 ]]; then
    echo -e "${__GRN}[INFO]${__NC} ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
  fi
}
#this is a function that alerts for failure. 
function alert () {
echo -e "${__BACK_RED}${__WHT}[FATAL] ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@${__NC}" >&2
}
#this is function that writes large amounts of debug output to another 
#logging system. 
function ext_log () {
echo -e "[LOG] ${BASH_SOURCE##*/}:${FUNCNAME[1]}: $@" >&2
}
# the trace function is to be overridden by the debug function supplied by
#the developer.
function trace () {
echo -e "[TRACE] ${BASH_SOURCE##*/}:${FUNCNAME[1]}: Currently Unsupported $@" >&2
}
#end

## ! END LOGGING LOG FUNCTIONS ##

function input_parse() {
###INPUT STUFF###
while [[ $# > 0 ]]
do
  key="$1"

  case $key in
    -r|--run-directory)
      RUN_DIR="$2"
      shift # past argument
      ;;
    -i|--input)
      INPUT="$2"
      shift # past argument
      ;;
    -d|--source-directory)
      SRC_DIR="$2"
      shift # past argument
      ;;
    -w|--web-directory)
      WEB_DIRECTORY="$2"
      shift # past argument
      ;;
    -s|--shared)
      SRC_DIR="$2"
      shift # past argument
      ;;
    --default)
      DEFAULT=YES
      ;;
#    --web-info)
#      WEB_INFO="$2"
#      if [ -a $WEB_INFO ]; then
#        WEB_INFO_EXISTS=true
#      fi
#      shift # past argument
#      ;;
    -v|--verbose)
      _V=1
      #shift # past argument
      ;;
    -vv|--verbose=2)
      _V=2
      #shift # past argument
      ;;
    -vvv|--verbose=3)
      _V=3
      #shift # past argument
      ;;
    -b|--background)
      _V=-1
      #shift # past argument
      ;;
    *)
      # unknown option
      ;;
  esac
  shift # past argument or value
done
unset key
}
## ! END INPUT SECTION ###

## MD5-SUM CHECK and GEN ##
## mario me baby..
# find point/analysis/* | tr '/' '_' | tr '.' '_' | sed -e 's/^/if \[ "$/' | sed -e 's/$/\ == $(md5sum \$1\/Makefile.intel | cut --delimiter=\" \" -f1 ) ]; then\n((__md5_files_temp++))\nlogvv "checksums OKAY -- "/' | temp=$(find point/analysis/* | tr '/' '_' | tr '.' '_') | 
# ooo bash sing me the sweet songs of your people...
# for file in point/analysis/* ; do ((echo -en $file |tr '/' '_' | tr '.' '_' | tr '-' '_' | sed -e 's/^/if \[ "$/' | sed -e 's/$/\" == $(md5sum \$1\//' && ( echo -en "${file#*/}" ) | sed -e 's/$/\ | cut --delimiter=\" \" -f1 ) ]; then\n((__md5_files_temp++))\nlogvv "checksums OKAY -- /') && ( echo -e "\$$file\"" |tr '/' '_' | tr '.' '_' | tr '-' '_' && echo -e "else" && echo -e "alert \"$(echo -e $file | tr '/' '_' | tr '.' '_' | tr '-' '_') did not match\"" && echo -e "fi" ) ) ; done 
#
# EYAH BABY

function md5_sum_check() {
local __md5_files_temp
__md5_files_temp=0 # $__md5_files
#__md5_files_temp=$(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./* | egrep -v '^d' | head -c-1 | wc -l)
# first arg is the folder/file
if [[ -a $1 ]]; then
  logvv "$1 exists"
  #this can be done externally, see the web scripts
#logvv "$1/Makefile"
#logvv "$(md5sum $1/Makefile | cut --delimiter=" " -f1)"
if [ "$point_bin_eos_mod" == $(md5sum $1/bin/eos.mod | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_bin_eos_mod"
else
alert "point_bin_eos_mod did not match"
fi
if [ "$point_bin_Makefile" == $(md5sum $1/bin/Makefile | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_bin_Makefile"
else
alert "point_bin_Makefile did not match"
fi
if [ "$point_bin_Makefile_columbia" == $(md5sum $1/bin/Makefile.columbia | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_bin_Makefile_columbia"
else
alert "point_bin_Makefile_columbia did not match"
fi
if [ "$point_bin_Makefile_debug" == $(md5sum $1/bin/Makefile.debug | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_bin_Makefile_debug"
else
alert "point_bin_Makefile_debug did not match"
fi
if [ "$point_bin_Makefile_DEFS" == $(md5sum $1/bin/Makefile.DEFS | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_bin_Makefile_DEFS"
else
alert "point_bin_Makefile_DEFS did not match"
fi
if [ "$point_bin_Makefile_endeavor" == $(md5sum $1/bin/Makefile.endeavor | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_bin_Makefile_endeavor"
else
alert "point_bin_Makefile_endeavor did not match"
fi
if [ "$point_bin_Makefile_gcc" == $(md5sum $1/bin/Makefile.gcc | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_bin_Makefile_gcc"
else
alert "point_bin_Makefile_gcc did not match"
fi
if [ "$point_bin_Makefile_intel" == $(md5sum $1/bin/Makefile.intel | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_bin_Makefile_intel"
else
alert "point_bin_Makefile_intel did not match"
fi
if [ "$point_bin_Makefile_pgf95" == $(md5sum $1/bin/Makefile.pgf95 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_bin_Makefile_pgf95"
else
alert "point_bin_Makefile_pgf95 did not match"
fi
if [ "$point_bin_particle_mod" == $(md5sum $1/bin/particle.mod | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_bin_particle_mod"
else
alert "point_bin_particle_mod did not match"
fi
if [ "$point_bin_utilities_mod" == $(md5sum $1/bin/utilities.mod | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_bin_utilities_mod"
else
alert "point_bin_utilities_mod did not match"
fi
#point analysis files.
if [ "$point_analysis_chympart2_f90" == $(md5sum $1/analysis/chympart2.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_chympart2_f90"
else
alert "point_analysis_chympart2_f90 did not match"
fi
if [ "$point_analysis_chympart_f90" == $(md5sum $1/analysis/chympart.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_chympart_f90"
else
alert "point_analysis_chympart_f90 did not match"
fi
if [ "$point_analysis_dustprof_f90" == $(md5sum $1/analysis/dustprof.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_dustprof_f90"
else
alert "point_analysis_dustprof_f90 did not match"
fi
if [ "$point_analysis_dustsig_f90" == $(md5sum $1/analysis/dustsig.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_dustsig_f90"
else
alert "point_analysis_dustsig_f90 did not match"
fi
if [ "$point_analysis_find_clump_py" == $(md5sum $1/analysis/find_clump.py | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_find_clump_py"
else
alert "point_analysis_find_clump_py did not match"
fi
if [ "$point_analysis_gastodust_f90" == $(md5sum $1/analysis/gastodust.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_gastodust_f90"
else
alert "point_analysis_gastodust_f90 did not match"
fi
if [ "$point_analysis_inject_az_f90" == $(md5sum $1/analysis/inject_az.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_inject_az_f90"
else
alert "point_analysis_inject_az_f90 did not match"
fi
if [ "$point_analysis_inject_rz_f90" == $(md5sum $1/analysis/inject_rz.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_inject_rz_f90"
else
alert "point_analysis_inject_rz_f90 did not match"
fi
if [ "$point_analysis_make_disk_model_py" == $(md5sum $1/analysis/make_disk_model.py | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_make_disk_model_py"
else
alert "point_analysis_make_disk_model_py did not match"
fi
if [ "$point_analysis_makeimage_py" == $(md5sum $1/analysis/makeimage.py | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_makeimage_py"
else
alert "point_analysis_makeimage_py did not match"
fi
if [ "$point_analysis_makemerid_sh" == $(md5sum $1/analysis/makemerid.sh | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_makemerid_sh"
else
alert "point_analysis_makemerid_sh did not match"
fi
if [ "$point_analysis_makesig_sh" == $(md5sum $1/analysis/makesig.sh | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_makesig_sh"
else
alert "point_analysis_makesig_sh did not match"
fi
if [ "$point_analysis_maxClump_f90" == $(md5sum $1/analysis/maxClump.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_maxClump_f90"
else
alert "point_analysis_maxClump_f90 did not match"
fi
if [ "$point_analysis_mdot_image_py" == $(md5sum $1/analysis/mdot_image.py | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_mdot_image_py"
else
alert "point_analysis_mdot_image_py did not match"
fi
if [ "$point_analysis_mdot_py" == $(md5sum $1/analysis/mdot.py | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_mdot_py"
else
alert "point_analysis_mdot_py did not match"
fi
if [ "$point_analysis_meridional_f90" == $(md5sum $1/analysis/meridional.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_meridional_f90"
else
alert "point_analysis_meridional_f90 did not match"
fi
if [ "$point_analysis_midplot" == $(md5sum $1/analysis/midplot | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_midplot"
else
alert "point_analysis_midplot did not match"
fi
if [ "$point_analysis_midplot_f90" == $(md5sum $1/analysis/midplot.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_midplot_f90"
else
alert "point_analysis_midplot_f90 did not match"
fi
if [ "$point_analysis_overden_f90" == $(md5sum $1/analysis/overden.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_overden_f90"
else
alert "point_analysis_overden_f90 did not match"
fi
if [ "$point_analysis_phase_f90" == $(md5sum $1/analysis/phase.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_phase_f90"
else
alert "point_analysis_phase_f90 did not match"
fi
if [ "$point_analysis_phiplot_f90" == $(md5sum $1/analysis/phiplot.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_phiplot_f90"
else
alert "point_analysis_phiplot_f90 did not match"
fi
if [ "$point_analysis_plotpart_f90" == $(md5sum $1/analysis/plotpart.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_plotpart_f90"
else
alert "point_analysis_plotpart_f90 did not match"
fi
if [ "$point_analysis_plotpart_sh" == $(md5sum $1/analysis/plotpart.sh | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_plotpart_sh"
else
alert "point_analysis_plotpart_sh did not match"
fi
if [ "$point_analysis_q_init" == $(md5sum $1/analysis/q.init | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_q_init"
else
alert "point_analysis_q_init did not match"
fi
if [ "$point_analysis_qlocal_py" == $(md5sum $1/analysis/qlocal.py | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_qlocal_py"
else
alert "point_analysis_qlocal_py did not match"
fi
if [ "$point_analysis_qprof_var" == $(md5sum $1/analysis/qprof_var | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_qprof_var"
else
alert "point_analysis_qprof_var did not match"
fi
if [ "$point_analysis_qprof_var_f90" == $(md5sum $1/analysis/qprof_var.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_qprof_var_f90"
else
alert "point_analysis_qprof_var_f90 did not match"
fi
if [ "$point_analysis_script_test" == $(md5sum $1/analysis/script_test | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_script_test"
else
alert "point_analysis_script_test did not match"
fi
if [ "$point_analysis_sigplot_f90" == $(md5sum $1/analysis/sigplot.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_sigplot_f90"
else
alert "point_analysis_sigplot_f90 did not match"
fi
if [ "$point_analysis_test_rho_png" == $(md5sum $1/analysis/test-rho.png | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_test_rho_png"
else
alert "point_analysis_test_rho_png did not match"
fi
if [ "$point_analysis_test_tk_png" == $(md5sum $1/analysis/test-tk.png | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_test_tk_png"
else
alert "point_analysis_test_tk_png did not match"
fi
if [ "$point_analysis_truelove2_f90" == $(md5sum $1/analysis/truelove2.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_truelove2_f90"
else
alert "point_analysis_truelove2_f90 did not match"
fi
if [ "$point_analysis_truelove_f90" == $(md5sum $1/analysis/truelove.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_truelove_f90"
else
alert "point_analysis_truelove_f90 did not match"
fi
if [ "$point_analysis_vplot_cyl_f90" == $(md5sum $1/analysis/vplot_cyl.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_vplot_cyl_f90"
else
alert "point_analysis_vplot_cyl_f90 did not match"
fi
if [ "$point_analysis_vplot_f90" == $(md5sum $1/analysis/vplot.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_vplot_f90"
else
alert "point_analysis_vplot_f90 did not match"
fi
#end point analysis files
#POINT ANALYSIS-UO
if [ "$point_analysis_uo_anal_dat" == $(md5sum $1/analysis-uo/anal.dat | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_anal_dat"
else
alert "point_analysis_uo_anal_dat did not match"
fi
if [ "$point_analysis_uo_a_out" == $(md5sum $1/analysis-uo/a.out | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_a_out"
else
alert "point_analysis_uo_a_out did not match"
fi
if [ "$point_analysis_uo_draw" == $(md5sum $1/analysis-uo/draw | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_draw"
else
alert "point_analysis_uo_draw did not match"
fi
if [ "$point_analysis_uo_draw128" == $(md5sum $1/analysis-uo/draw128 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_draw128"
else
alert "point_analysis_uo_draw128 did not match"
fi
if [ "$point_analysis_uo_drawcontour" == $(md5sum $1/analysis-uo/drawcontour | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_drawcontour"
else
alert "point_analysis_uo_drawcontour did not match"
fi
if [ "$point_analysis_uo_drawcontour_f" == $(md5sum $1/analysis-uo/drawcontour.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_drawcontour_f"
else
alert "point_analysis_uo_drawcontour_f did not match"
fi
if [ "$point_analysis_uo_eigen128" == $(md5sum $1/analysis-uo/eigen128 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_eigen128"
else
alert "point_analysis_uo_eigen128 did not match"
fi
if [ "$point_analysis_uo_eigen1_f" == $(md5sum $1/analysis-uo/eigen1.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_eigen1_f"
else
alert "point_analysis_uo_eigen1_f did not match"
fi
if [ "$point_analysis_uo_eigen_f" == $(md5sum $1/analysis-uo/eigen.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_eigen_f"
else
alert "point_analysis_uo_eigen_f did not match"
fi
if [ "$point_analysis_uo_flat_f" == $(md5sum $1/analysis-uo/flat.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_flat_f"
else
alert "point_analysis_uo_flat_f did not match"
fi
if [ "$point_analysis_uo_param_h" == $(md5sum $1/analysis-uo/param.h | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_param_h"
else
alert "point_analysis_uo_param_h did not match"
fi
if [ "$point_analysis_uo_plotcontour" == $(md5sum $1/analysis-uo/plotcontour | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_plotcontour"
else
alert "point_analysis_uo_plotcontour did not match"
fi
if [ "$point_analysis_uo_ploteigen" == $(md5sum $1/analysis-uo/ploteigen | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_ploteigen"
else
alert "point_analysis_uo_ploteigen did not match"
fi
if [ "$point_analysis_uo_poly" == $(md5sum $1/analysis-uo/poly | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_poly"
else
alert "point_analysis_uo_poly did not match"
fi
if [ "$point_analysis_uo_polyout" == $(md5sum $1/analysis-uo/polyout | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_polyout"
else
alert "point_analysis_uo_polyout did not match"
fi
if [ "$point_analysis_uo_resolved_amplitude_ps" == $(md5sum $1/analysis-uo/resolved-amplitude.ps | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_resolved_amplitude_ps"
else
alert "point_analysis_uo_resolved_amplitude_ps did not match"
fi
if [ "$point_analysis_uo_sigplot" == $(md5sum $1/analysis-uo/sigplot | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_sigplot"
else
alert "point_analysis_uo_sigplot did not match"
fi
if [ "$point_analysis_uo_star_disk_in" == $(md5sum $1/analysis-uo/star_disk.in | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_analysis_uo_star_disk_in"
else
alert "point_analysis_uo_star_disk_in did not match"
fi
#end POINT ANALYSIS-UO
# POINT EOS
if [ "$point_eos_eos_f90" == $(md5sum $1/eos/eos.f90 | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_eos_eos_f90"
else
alert "point_eos_eos_f90 did not match"
fi
if [ "$point_eos_initengtable_f_obsolete" == $(md5sum $1/eos/initengtable.f.obsolete | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_eos_initengtable_f_obsolete"
else
alert "point_eos_initengtable_f_obsolete did not match"
fi
if [ "$point_eos_state_f" == $(md5sum $1/eos/state.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_eos_state_f"
else
alert "point_eos_state_f did not match"
fi
if [ "$point_eos_state_f_obsolete" == $(md5sum $1/eos/state.f.obsolete | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_eos_state_f_obsolete"
else
alert "point_eos_state_f_obsolete did not match"
fi
# END POINT EOS
# POINT FLUID
if [ "$point_fluid_fluid_advance_F" == $(md5sum $1/fluid/fluid_advance.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_fluid_advance_F"
else
alert "point_fluid_fluid_advance_F did not match"
fi
if [ "$point_fluid_fluid_interp_F" == $(md5sum $1/fluid/fluid_interp.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_fluid_interp_F"
else
alert "point_fluid_fluid_interp_F did not match"
fi
if [ "$point_fluid_fluid_mod_F" == $(md5sum $1/fluid/fluid_mod.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_fluid_mod_F"
else
alert "point_fluid_fluid_mod_F did not match"
fi
if [ "$point_fluid_fluid_restart_F" == $(md5sum $1/fluid/fluid_restart.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_fluid_restart_F"
else
alert "point_fluid_fluid_restart_F did not match"
fi
if [ "$point_fluid_fluid_setup_F" == $(md5sum $1/fluid/fluid_setup.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_fluid_setup_F"
else
alert "point_fluid_fluid_setup_F did not match"
fi
if [ "$point_fluid_fluid_start_F" == $(md5sum $1/fluid/fluid_start.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_fluid_start_F"
else
alert "point_fluid_fluid_start_F did not match"
fi
if [ "$point_fluid_fluid_writeout_F" == $(md5sum $1/fluid/fluid_writeout.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_fluid_writeout_F"
else
alert "point_fluid_fluid_writeout_F did not match"
fi
if [ "$point_fluid_interp_1alloc_c" == $(md5sum $1/fluid/interp_1alloc.c | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_interp_1alloc_c"
else
alert "point_fluid_interp_1alloc_c did not match"
fi
if [ "$point_fluid_interp_c" == $(md5sum $1/fluid/interp.c | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_interp_c"
else
alert "point_fluid_interp_c did not match"
fi
if [ "$point_fluid_interp_project_F" == $(md5sum $1/fluid/interp_project.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_interp_project_F"
else
alert "point_fluid_interp_project_F did not match"
fi
if [ "$point_fluid_old_fluid_advance_F" == $(md5sum $1/fluid/old/fluid_advance.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_old_fluid_advance_F"
else
alert "point_fluid_old_fluid_advance_F did not match"
fi
if [ "$point_fluid_old_fluid_interp_F" == $(md5sum $1/fluid/old/fluid_interp.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_old_fluid_interp_F"
else
alert "point_fluid_old_fluid_interp_F did not match"
fi
if [ "$point_fluid_old_fluid_mod_F" == $(md5sum $1/fluid/old/fluid_mod.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_old_fluid_mod_F"
else
alert "point_fluid_old_fluid_mod_F did not match"
fi
if [ "$point_fluid_old_fluid_restart_F" == $(md5sum $1/fluid/old/fluid_restart.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_old_fluid_restart_F"
else
alert "point_fluid_old_fluid_restart_F did not match"
fi
if [ "$point_fluid_old_fluid_setup_F" == $(md5sum $1/fluid/old/fluid_setup.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_old_fluid_setup_F"
else
alert "point_fluid_old_fluid_setup_F did not match"
fi
if [ "$point_fluid_old_fluid_start_F" == $(md5sum $1/fluid/old/fluid_start.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_old_fluid_start_F"
else
alert "point_fluid_old_fluid_start_F did not match"
fi
if [ "$point_fluid_old_fluid_writeout_F" == $(md5sum $1/fluid/old/fluid_writeout.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_old_fluid_writeout_F"
else
alert "point_fluid_old_fluid_writeout_F did not match"
fi
if [ "$point_fluid_old_interp_1alloc_c" == $(md5sum $1/fluid/old/interp_1alloc.c | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_old_interp_1alloc_c"
else
alert "point_fluid_old_interp_1alloc_c did not match"
fi
if [ "$point_fluid_old_interp_c" == $(md5sum $1/fluid/old/interp.c | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_old_interp_c"
else
alert "point_fluid_old_interp_c did not match"
fi
if [ "$point_fluid_old_interp_project_F" == $(md5sum $1/fluid/old/interp_project.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_fluid_old_interp_project_F"
else
alert "point_fluid_old_interp_project_F did not match"
fi
# END POINT FLUID
# POINT HEADERS
if [ "$point_headers_globals_h" == $(md5sum $1/headers/globals.h | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_headers_globals_h"
else
alert "point_headers_globals_h did not match"
fi
if [ "$point_headers_globals_h_old" == $(md5sum $1/headers/globals.h.old | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_headers_globals_h_old"
else
alert "point_headers_globals_h_old did not match"
fi
if [ "$point_headers_hydroparam_h" == $(md5sum $1/headers/hydroparam.h | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_headers_hydroparam_h"
else
alert "point_headers_hydroparam_h did not match"
fi
if [ "$point_headers_readme_txt" == $(md5sum $1/headers/readme.txt | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_headers_readme_txt"
else
alert "point_headers_readme_txt did not match"
fi
if [ "$point_headers_units_h" == $(md5sum $1/headers/units.h | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_headers_units_h"
else
alert "point_headers_units_h did not match"
fi
# END POINT HEADERS
# POINT LEGACY
if [ "$point_legacy_opas_f" == $(md5sum $1/legacy/opas.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_legacy_opas_f"
else
alert "point_legacy_opas_f did not match"
fi
if [ "$point_legacy_pmm_dat" == $(md5sum $1/legacy/pmm.dat | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_legacy_pmm_dat"
else
alert "point_legacy_pmm_dat did not match"
fi
if [ "$point_legacy_README" == $(md5sum $1/legacy/README | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_legacy_README"
else
alert "point_legacy_README did not match"
fi
# END POINT LEGACY
# POINT PARTICLES
if [ "$point_particles_particle_module_f" == $(md5sum $1/particles/particle_module.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_particles_particle_module_f"
else
alert "point_particles_particle_module_f did not match"
fi
if [ "$point_particles_particle_module_f90_obsolete" == $(md5sum $1/particles/particle_module.f90.obsolete | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_particles_particle_module_f90_obsolete"
else
alert "point_particles_particle_module_f90_obsolete did not match"
fi
# END POINT PARTICLES
# POINT PATCH
if [ "$point_patch_ExternalRoutines_f" == $(md5sum $1/patch/ExternalRoutines.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_ExternalRoutines_f"
else
alert "point_patch_ExternalRoutines_f did not match"
fi
if [ "$point_patch_passive_f" == $(md5sum $1/patch/passive.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_passive_f"
else
alert "point_patch_passive_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_3dhyd_main_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/3dhyd-main.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_3dhyd_main_f"
else
alert "point_patch_patch_particle_should_be_obsolete_3dhyd_main_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_boundary_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/boundary.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_boundary_f"
else
alert "point_patch_patch_particle_should_be_obsolete_boundary_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_ExternalPot_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/ExternalPot.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_ExternalPot_f"
else
alert "point_patch_patch_particle_should_be_obsolete_ExternalPot_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_ExternalRoutines_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/ExternalRoutines.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_ExternalRoutines_f"
else
alert "point_patch_patch_particle_should_be_obsolete_ExternalRoutines_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_flux_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/flux.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_flux_f"
else
alert "point_patch_patch_particle_should_be_obsolete_flux_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_housekeeping_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/housekeeping.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_housekeeping_f"
else
alert "point_patch_patch_particle_should_be_obsolete_housekeeping_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_hybrid_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/hybrid.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_hybrid_f"
else
alert "point_patch_patch_particle_should_be_obsolete_hybrid_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_io_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/io.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_io_f"
else
alert "point_patch_patch_particle_should_be_obsolete_io_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_io_f_full" == $(md5sum $1/patch/patch_particle_should_be_obsolete/io.f.full | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_io_f_full"
else
alert "point_patch_patch_particle_should_be_obsolete_io_f_full did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_misc_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/misc.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_misc_f"
else
alert "point_patch_patch_particle_should_be_obsolete_misc_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_misc_f_save" == $(md5sum $1/patch/patch_particle_should_be_obsolete/misc.f.save | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_misc_f_save"
else
alert "point_patch_patch_particle_should_be_obsolete_misc_f_save did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_particle_module_cart_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.cart.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_particle_module_cart_f"
else
alert "point_patch_patch_particle_should_be_obsolete_particle_module_cart_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_particle_module_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_particle_module_f"
else
alert "point_patch_patch_particle_should_be_obsolete_particle_module_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_particle_module_f_full" == $(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f.full | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_particle_module_f_full"
else
alert "point_patch_patch_particle_should_be_obsolete_particle_module_f_full did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_particle_module_f_jn" == $(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f.jn | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_particle_module_f_jn"
else
alert "point_patch_patch_particle_should_be_obsolete_particle_module_f_jn did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_particle_module_fomp" == $(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.fomp | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_particle_module_fomp"
else
alert "point_patch_patch_particle_should_be_obsolete_particle_module_fomp did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_particle_module_f_omp" == $(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f.omp | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_particle_module_f_omp"
else
alert "point_patch_patch_particle_should_be_obsolete_particle_module_f_omp did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_particle_module_f_save" == $(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f.save | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_particle_module_f_save"
else
alert "point_patch_patch_particle_should_be_obsolete_particle_module_f_save did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_particle_module_f_static" == $(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f.static | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_particle_module_f_static"
else
alert "point_patch_patch_particle_should_be_obsolete_particle_module_f_static did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_particle_module_f_working" == $(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f.working | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_particle_module_f_working"
else
alert "point_patch_patch_particle_should_be_obsolete_particle_module_f_working did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_passive_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/passive.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_passive_f"
else
alert "point_patch_patch_particle_should_be_obsolete_passive_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_pot3_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/pot3.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_pot3_f"
else
alert "point_patch_patch_particle_should_be_obsolete_pot3_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_RadTran_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/RadTran.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_RadTran_f"
else
alert "point_patch_patch_particle_should_be_obsolete_RadTran_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_RadTran_f_save" == $(md5sum $1/patch/patch_particle_should_be_obsolete/RadTran.f.save | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_RadTran_f_save"
else
alert "point_patch_patch_particle_should_be_obsolete_RadTran_f_save did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_README" == $(md5sum $1/patch/patch_particle_should_be_obsolete/README | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_README"
else
alert "point_patch_patch_particle_should_be_obsolete_README did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_source_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/source.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_source_f"
else
alert "point_patch_patch_particle_should_be_obsolete_source_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_state_f" == $(md5sum $1/patch/patch_particle_should_be_obsolete/state.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_state_f"
else
alert "point_patch_patch_particle_should_be_obsolete_state_f did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_tcart" == $(md5sum $1/patch/patch_particle_should_be_obsolete/tcart | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_tcart"
else
alert "point_patch_patch_particle_should_be_obsolete_tcart did not match"
fi
if [ "$point_patch_patch_particle_should_be_obsolete_wiggle_F" == $(md5sum $1/patch/patch_particle_should_be_obsolete/wiggle.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_patch_patch_particle_should_be_obsolete_wiggle_F"
else
alert "point_patch_patch_particle_should_be_obsolete_wiggle_F did not match"
fi
# END POINT PATCH
# POINT POT
if [ "$point_pot_blktri_f" == $(md5sum $1/pot/blktri.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_pot_blktri_f"
else
alert "point_pot_blktri_f did not match"
fi
if [ "$point_pot_boundary_f" == $(md5sum $1/pot/boundary.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_pot_boundary_f"
else
alert "point_pot_boundary_f did not match"
fi
if [ "$point_pot_ExternalPot_f" == $(md5sum $1/pot/ExternalPot.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_pot_ExternalPot_f"
else
alert "point_pot_ExternalPot_f did not match"
fi
if [ "$point_pot_ExternalPot_original2_f" == $(md5sum $1/pot/ExternalPot.original2.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_pot_ExternalPot_original2_f"
else
alert "point_pot_ExternalPot_original2_f did not match"
fi
if [ "$point_pot_ExternalPot_original_f" == $(md5sum $1/pot/ExternalPot.original.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_pot_ExternalPot_original_f"
else
alert "point_pot_ExternalPot_original_f did not match"
fi
if [ "$point_pot_fft_f" == $(md5sum $1/pot/fft.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_pot_fft_f"
else
alert "point_pot_fft_f did not match"
fi
if [ "$point_pot_pot3_f" == $(md5sum $1/pot/pot3.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_pot_pot3_f"
else
alert "point_pot_pot3_f did not match"
fi
if [ "$point_pot_wiggle_F" == $(md5sum $1/pot/wiggle.F | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_pot_wiggle_F"
else
alert "point_pot_wiggle_F did not match"
fi
# END POINT POT
# POINT RADHYDRO
if [ "$point_radhydro_3dhyd_main_diff" == $(md5sum $1/radhydro/3dhyd-main.diff | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_3dhyd_main_diff"
else
alert "point_radhydro_3dhyd_main_diff did not match"
fi
if [ "$point_radhydro_3dhyd_main_f" == $(md5sum $1/radhydro/3dhyd-main.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_3dhyd_main_f"
else
alert "point_radhydro_3dhyd_main_f did not match"
fi
if [ "$point_radhydro_avisc_f" == $(md5sum $1/radhydro/avisc.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_avisc_f"
else
alert "point_radhydro_avisc_f did not match"
fi
if [ "$point_radhydro_CoolingPrescriptions_f" == $(md5sum $1/radhydro/CoolingPrescriptions.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_CoolingPrescriptions_f"
else
alert "point_radhydro_CoolingPrescriptions_f did not match"
fi
if [ "$point_radhydro_diff_txt" == $(md5sum $1/radhydro/diff.txt | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_diff_txt"
else
alert "point_radhydro_diff_txt did not match"
fi
if [ "$point_radhydro_ExternalRoutines_f" == $(md5sum $1/radhydro/ExternalRoutines.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_ExternalRoutines_f"
else
alert "point_radhydro_ExternalRoutines_f did not match"
fi
if [ "$point_radhydro_flux_f" == $(md5sum $1/radhydro/flux.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_flux_f"
else
alert "point_radhydro_flux_f did not match"
fi
if [ "$point_radhydro_housekeeping_f" == $(md5sum $1/radhydro/housekeeping.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_housekeeping_f"
else
alert "point_radhydro_housekeeping_f did not match"
fi
if [ "$point_radhydro_hybrid_f" == $(md5sum $1/radhydro/hybrid.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_hybrid_f"
else
alert "point_radhydro_hybrid_f did not match"
fi
if [ "$point_radhydro_hybrid_old_nosubcycle_f" == $(md5sum $1/radhydro/hybrid.old.nosubcycle.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_hybrid_old_nosubcycle_f"
else
alert "point_radhydro_hybrid_old_nosubcycle_f did not match"
fi
if [ "$point_radhydro_io_diff" == $(md5sum $1/radhydro/io.diff | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_io_diff"
else
alert "point_radhydro_io_diff did not match"
fi
if [ "$point_radhydro_io_f" == $(md5sum $1/radhydro/io.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_io_f"
else
alert "point_radhydro_io_f did not match"
fi
if [ "$point_radhydro_misc_f" == $(md5sum $1/radhydro/misc.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_misc_f"
else
alert "point_radhydro_misc_f did not match"
fi
if [ "$point_radhydro_orig_3dhyd_main_f" == $(md5sum $1/radhydro/orig_3dhyd-main.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_orig_3dhyd_main_f"
else
alert "point_radhydro_orig_3dhyd_main_f did not match"
fi
if [ "$point_radhydro_passive_f" == $(md5sum $1/radhydro/passive.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_passive_f"
else
alert "point_radhydro_passive_f did not match"
fi
if [ "$point_radhydro_rad_f" == $(md5sum $1/radhydro/rad.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_rad_f"
else
alert "point_radhydro_rad_f did not match"
fi
if [ "$point_radhydro_RadTran_f" == $(md5sum $1/radhydro/RadTran.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_RadTran_f"
else
alert "point_radhydro_RadTran_f did not match"
fi
if [ "$point_radhydro_source_f" == $(md5sum $1/radhydro/source.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_source_f"
else
alert "point_radhydro_source_f did not match"
fi
if [ "$point_radhydro_w_3dhyd_main_f" == $(md5sum $1/radhydro/w_3dhyd-main.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_w_3dhyd_main_f"
else
alert "point_radhydro_w_3dhyd_main_f did not match"
fi
if [ "$point_radhydro_w_io_f" == $(md5sum $1/radhydro/w_io.f | cut --delimiter=" " -f1 ) ]; then
((__md5_files_temp++))
logvv "checksums OKAY -- $point_radhydro_w_io_f"
else
alert "point_radhydro_w_io_f did not match"
fi
# END POINT RADHYDRO
# END POINT
fi
log "MD5SUM $__md5_files_temp of $__md5_files"
unset __md5_files_temp
}
function md5_sum_gen() {
# first arg is the folder/file
local __md5_files_temp
__md5_files_temp=0 #$__md5_files
if [[ -a $1 ]]; then
  logvv "$1 exists"
  #can you say mario to this next line. 
#  __md5_files=$(ls -lBAqd --ignore=".*" --ignore=".." --ignore="*.swp" --ignore="*.tmp" ./* | egrep -v '^d' | head -c-1 | wc -l)
  logv "Running $__md5_files_temp hashes, unless you expected this warning, this model maybe altered"
  #this can be done externally, see the web scripts
point_bin_eos_mod=$(md5sum $1/bin/eos.mod | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_bin_eos_mod=$point_bin_eos_mod"
else
alert "point/bin/eos.mod error'd out"
fi
point_bin_Makefile=$(md5sum $1/bin/Makefile | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_bin_Makefile=$point_bin_Makefile"
else
alert "point/bin/Makefile error'd out"
fi
point_bin_Makefile_columbia=$(md5sum $1/bin/Makefile.columbia | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_bin_Makefile_columbia=$point_bin_Makefile_columbia"
else
alert "point/bin/Makefile.columbia error'd out"
fi
point_bin_Makefile_debug=$(md5sum $1/bin/Makefile.debug | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_bin_Makefile_debug=$point_bin_Makefile_debug"
else
alert "point/bin/Makefile.debug error'd out"
fi
point_bin_Makefile_DEFS=$(md5sum $1/bin/Makefile.DEFS | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_bin_Makefile_DEFS=$point_bin_Makefile_DEFS"
else
alert "point/bin/Makefile.DEFS error'd out"
fi
point_bin_Makefile_endeavor=$(md5sum $1/bin/Makefile.endeavor | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_bin_Makefile_endeavor=$point_bin_Makefile_endeavor"
else
alert "point/bin/Makefile.endeavor error'd out"
fi
point_bin_Makefile_gcc=$(md5sum $1/bin/Makefile.gcc | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_bin_Makefile_gcc=$point_bin_Makefile_gcc"
else
alert "point/bin/Makefile.gcc error'd out"
fi
point_bin_Makefile_intel=$(md5sum $1/bin/Makefile.intel | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_bin_Makefile_intel=$point_bin_Makefile_intel"
else
alert "point/bin/Makefile.intel error'd out"
fi
point_bin_Makefile_pgf95=$(md5sum $1/bin/Makefile.pgf95 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_bin_Makefile_pgf95=$point_bin_Makefile_pgf95"
else
alert "point/bin/Makefile.pgf95 error'd out"
fi
point_bin_particle_mod=$(md5sum $1/bin/particle.mod | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_bin_particle_mod=$point_bin_particle_mod"
else
alert "point/bin/particle.mod error'd out"
fi
point_bin_utilities_mod=$(md5sum $1/bin/utilities.mod | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_bin_utilities_mod=$point_bin_utilities_mod"
else
alert "point/bin/utilities.mod error'd out"
fi
#begin analysis section
# Some mario magic for ya...
# for file in point/analysis/* ; do ((echo -en $file | tr '/' '_' | tr '.' '_' | tr '-' '_' | sed -e 's/$/\=$(md5sum \$1\//' && ( echo -en "${file#*/}" ) | sed -e 's/$/\ | cut --delimiter=\" \" -f1 )\nif [ "$?" ==  0 ]; then\n((__md5_files_temp++))\nlogvv "/') && ( echo -en "$file" |tr '/' '_' | tr '.' '_' | tr '-' '_' && echo -e "=\$$(echo -e $file | tr '/' '_' | tr '.' '_' | tr '-' '_' )\"" ) && echo -e "else\nalert \"$file error'd out\"\nfi") ; done
#

point_analysis_chympart2_f90=$(md5sum $1/analysis/chympart2.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_chympart2_f90=$point_analysis_chympart2_f90"
else
alert "point/analysis/chympart2.f90 error'd out"
fi
point_analysis_chympart_f90=$(md5sum $1/analysis/chympart.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_chympart_f90=$point_analysis_chympart_f90"
else
alert "point/analysis/chympart.f90 error'd out"
fi
point_analysis_dustprof_f90=$(md5sum $1/analysis/dustprof.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_dustprof_f90=$point_analysis_dustprof_f90"
else
alert "point/analysis/dustprof.f90 error'd out"
fi
point_analysis_dustsig_f90=$(md5sum $1/analysis/dustsig.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_dustsig_f90=$point_analysis_dustsig_f90"
else
alert "point/analysis/dustsig.f90 error'd out"
fi
point_analysis_find_clump_py=$(md5sum $1/analysis/find_clump.py | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_find_clump_py=$point_analysis_find_clump_py"
else
alert "point/analysis/find_clump.py error'd out"
fi
point_analysis_gastodust_f90=$(md5sum $1/analysis/gastodust.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_gastodust_f90=$point_analysis_gastodust_f90"
else
alert "point/analysis/gastodust.f90 error'd out"
fi
point_analysis_inject_az_f90=$(md5sum $1/analysis/inject_az.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_inject_az_f90=$point_analysis_inject_az_f90"
else
alert "point/analysis/inject_az.f90 error'd out"
fi
point_analysis_inject_rz_f90=$(md5sum $1/analysis/inject_rz.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_inject_rz_f90=$point_analysis_inject_rz_f90"
else
alert "point/analysis/inject_rz.f90 error'd out"
fi
point_analysis_make_disk_model_py=$(md5sum $1/analysis/make_disk_model.py | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_make_disk_model_py=$point_analysis_make_disk_model_py"
else
alert "point/analysis/make_disk_model.py error'd out"
fi
point_analysis_makeimage_py=$(md5sum $1/analysis/makeimage.py | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_makeimage_py=$point_analysis_makeimage_py"
else
alert "point/analysis/makeimage.py error'd out"
fi
point_analysis_makemerid_sh=$(md5sum $1/analysis/makemerid.sh | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_makemerid_sh=$point_analysis_makemerid_sh"
else
alert "point/analysis/makemerid.sh error'd out"
fi
point_analysis_makesig_sh=$(md5sum $1/analysis/makesig.sh | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_makesig_sh=$point_analysis_makesig_sh"
else
alert "point/analysis/makesig.sh error'd out"
fi
point_analysis_maxClump_f90=$(md5sum $1/analysis/maxClump.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_maxClump_f90=$point_analysis_maxClump_f90"
else
alert "point/analysis/maxClump.f90 error'd out"
fi
point_analysis_mdot_image_py=$(md5sum $1/analysis/mdot_image.py | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_mdot_image_py=$point_analysis_mdot_image_py"
else
alert "point/analysis/mdot_image.py error'd out"
fi
point_analysis_mdot_py=$(md5sum $1/analysis/mdot.py | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_mdot_py=$point_analysis_mdot_py"
else
alert "point/analysis/mdot.py error'd out"
fi
point_analysis_meridional_f90=$(md5sum $1/analysis/meridional.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_meridional_f90=$point_analysis_meridional_f90"
else
alert "point/analysis/meridional.f90 error'd out"
fi
point_analysis_midplot=$(md5sum $1/analysis/midplot | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_midplot=$point_analysis_midplot"
else
alert "point/analysis/midplot error'd out"
fi
point_analysis_midplot_f90=$(md5sum $1/analysis/midplot.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_midplot_f90=$point_analysis_midplot_f90"
else
alert "point/analysis/midplot.f90 error'd out"
fi
point_analysis_overden_f90=$(md5sum $1/analysis/overden.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_overden_f90=$point_analysis_overden_f90"
else
alert "point/analysis/overden.f90 error'd out"
fi
point_analysis_phase_f90=$(md5sum $1/analysis/phase.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_phase_f90=$point_analysis_phase_f90"
else
alert "point/analysis/phase.f90 error'd out"
fi
point_analysis_phiplot_f90=$(md5sum $1/analysis/phiplot.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_phiplot_f90=$point_analysis_phiplot_f90"
else
alert "point/analysis/phiplot.f90 error'd out"
fi
point_analysis_plotpart_f90=$(md5sum $1/analysis/plotpart.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_plotpart_f90=$point_analysis_plotpart_f90"
else
alert "point/analysis/plotpart.f90 error'd out"
fi
point_analysis_plotpart_sh=$(md5sum $1/analysis/plotpart.sh | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_plotpart_sh=$point_analysis_plotpart_sh"
else
alert "point/analysis/plotpart.sh error'd out"
fi
point_analysis_q_init=$(md5sum $1/analysis/q.init | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_q_init=$point_analysis_q_init"
else
alert "point/analysis/q.init error'd out"
fi
point_analysis_qlocal_py=$(md5sum $1/analysis/qlocal.py | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_qlocal_py=$point_analysis_qlocal_py"
else
alert "point/analysis/qlocal.py error'd out"
fi
point_analysis_qprof_var=$(md5sum $1/analysis/qprof_var | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_qprof_var=$point_analysis_qprof_var"
else
alert "point/analysis/qprof_var error'd out"
fi
point_analysis_qprof_var_f90=$(md5sum $1/analysis/qprof_var.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_qprof_var_f90=$point_analysis_qprof_var_f90"
else
alert "point/analysis/qprof_var.f90 error'd out"
fi
point_analysis_script_test=$(md5sum $1/analysis/script_test | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_script_test=$point_analysis_script_test"
else
alert "point/analysis/script_test error'd out"
fi
point_analysis_sigplot_f90=$(md5sum $1/analysis/sigplot.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_sigplot_f90=$point_analysis_sigplot_f90"
else
alert "point/analysis/sigplot.f90 error'd out"
fi
point_analysis_test_rho_png=$(md5sum $1/analysis/test-rho.png | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_test_rho_png=$point_analysis_test_rho_png"
else
alert "point/analysis/test-rho.png error'd out"
fi
point_analysis_test_tk_png=$(md5sum $1/analysis/test-tk.png | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_test_tk_png=$point_analysis_test_tk_png"
else
alert "point/analysis/test-tk.png error'd out"
fi
point_analysis_truelove2_f90=$(md5sum $1/analysis/truelove2.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_truelove2_f90=$point_analysis_truelove2_f90"
else
alert "point/analysis/truelove2.f90 error'd out"
fi
point_analysis_truelove_f90=$(md5sum $1/analysis/truelove.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_truelove_f90=$point_analysis_truelove_f90"
else
alert "point/analysis/truelove.f90 error'd out"
fi
point_analysis_vplot_cyl_f90=$(md5sum $1/analysis/vplot_cyl.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_vplot_cyl_f90=$point_analysis_vplot_cyl_f90"
else
alert "point/analysis/vplot_cyl.f90 error'd out"
fi
point_analysis_vplot_f90=$(md5sum $1/analysis/vplot.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_vplot_f90=$point_analysis_vplot_f90"
else
alert "point/analysis/vplot.f90 error'd out"
fi
#end analysis
# ANALYSIS-UO
point_analysis_uo_anal_dat=$(md5sum $1/analysis-uo/anal.dat | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_anal_dat=$point_analysis_uo_anal_dat"
else
alert "point/analysis-uo/anal.dat error'd out"
fi
point_analysis_uo_a_out=$(md5sum $1/analysis-uo/a.out | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_a_out=$point_analysis_uo_a_out"
else
alert "point/analysis-uo/a.out error'd out"
fi
point_analysis_uo_draw=$(md5sum $1/analysis-uo/draw | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_draw=$point_analysis_uo_draw"
else
alert "point/analysis-uo/draw error'd out"
fi
point_analysis_uo_draw128=$(md5sum $1/analysis-uo/draw128 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_draw128=$point_analysis_uo_draw128"
else
alert "point/analysis-uo/draw128 error'd out"
fi
point_analysis_uo_drawcontour=$(md5sum $1/analysis-uo/drawcontour | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_drawcontour=$point_analysis_uo_drawcontour"
else
alert "point/analysis-uo/drawcontour error'd out"
fi
point_analysis_uo_drawcontour_f=$(md5sum $1/analysis-uo/drawcontour.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_drawcontour_f=$point_analysis_uo_drawcontour_f"
else
alert "point/analysis-uo/drawcontour.f error'd out"
fi
point_analysis_uo_eigen128=$(md5sum $1/analysis-uo/eigen128 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_eigen128=$point_analysis_uo_eigen128"
else
alert "point/analysis-uo/eigen128 error'd out"
fi
point_analysis_uo_eigen1_f=$(md5sum $1/analysis-uo/eigen1.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_eigen1_f=$point_analysis_uo_eigen1_f"
else
alert "point/analysis-uo/eigen1.f error'd out"
fi
point_analysis_uo_eigen_f=$(md5sum $1/analysis-uo/eigen.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_eigen_f=$point_analysis_uo_eigen_f"
else
alert "point/analysis-uo/eigen.f error'd out"
fi
point_analysis_uo_flat_f=$(md5sum $1/analysis-uo/flat.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_flat_f=$point_analysis_uo_flat_f"
else
alert "point/analysis-uo/flat.f error'd out"
fi
point_analysis_uo_param_h=$(md5sum $1/analysis-uo/param.h | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_param_h=$point_analysis_uo_param_h"
else
alert "point/analysis-uo/param.h error'd out"
fi
point_analysis_uo_plotcontour=$(md5sum $1/analysis-uo/plotcontour | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_plotcontour=$point_analysis_uo_plotcontour"
else
alert "point/analysis-uo/plotcontour error'd out"
fi
point_analysis_uo_ploteigen=$(md5sum $1/analysis-uo/ploteigen | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_ploteigen=$point_analysis_uo_ploteigen"
else
alert "point/analysis-uo/ploteigen error'd out"
fi
point_analysis_uo_poly=$(md5sum $1/analysis-uo/poly | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_poly=$point_analysis_uo_poly"
else
alert "point/analysis-uo/poly error'd out"
fi
point_analysis_uo_polyout=$(md5sum $1/analysis-uo/polyout | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_polyout=$point_analysis_uo_polyout"
else
alert "point/analysis-uo/polyout error'd out"
fi
point_analysis_uo_resolved_amplitude_ps=$(md5sum $1/analysis-uo/resolved-amplitude.ps | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_resolved_amplitude_ps=$point_analysis_uo_resolved_amplitude_ps"
else
alert "point/analysis-uo/resolved-amplitude.ps error'd out"
fi
point_analysis_uo_sigplot=$(md5sum $1/analysis-uo/sigplot | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_sigplot=$point_analysis_uo_sigplot"
else
alert "point/analysis-uo/sigplot error'd out"
fi
point_analysis_uo_star_disk_in=$(md5sum $1/analysis-uo/star_disk.in | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_analysis_uo_star_disk_in=$point_analysis_uo_star_disk_in"
else
alert "point/analysis-uo/star_disk.in error'd out"
fi
#END ANALYSIS-UO
# POINT EOS
point_eos_eos_f90=$(md5sum $1/eos/eos.f90 | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_eos_eos_f90=$point_eos_eos_f90"
else
alert "point/eos/eos.f90 error'd out"
fi
point_eos_initengtable_f_obsolete=$(md5sum $1/eos/initengtable.f.obsolete | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_eos_initengtable_f_obsolete=$point_eos_initengtable_f_obsolete"
else
alert "point/eos/initengtable.f.obsolete error'd out"
fi
point_eos_state_f=$(md5sum $1/eos/state.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_eos_state_f=$point_eos_state_f"
else
alert "point/eos/state.f error'd out"
fi
point_eos_state_f_obsolete=$(md5sum $1/eos/state.f.obsolete | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_eos_state_f_obsolete=$point_eos_state_f_obsolete"
else
alert "point/eos/state.f.obsolete error'd out"
fi
# END POINT EOS
# POINT FLUID
point_fluid_fluid_advance_F=$(md5sum $1/fluid/fluid_advance.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_fluid_advance_F=$point_fluid_fluid_advance_F"
else
alert "point/fluid/fluid_advance.F error'd out"
fi
point_fluid_fluid_interp_F=$(md5sum $1/fluid/fluid_interp.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_fluid_interp_F=$point_fluid_fluid_interp_F"
else
alert "point/fluid/fluid_interp.F error'd out"
fi
point_fluid_fluid_mod_F=$(md5sum $1/fluid/fluid_mod.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_fluid_mod_F=$point_fluid_fluid_mod_F"
else
alert "point/fluid/fluid_mod.F error'd out"
fi
point_fluid_fluid_restart_F=$(md5sum $1/fluid/fluid_restart.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_fluid_restart_F=$point_fluid_fluid_restart_F"
else
alert "point/fluid/fluid_restart.F error'd out"
fi
point_fluid_fluid_setup_F=$(md5sum $1/fluid/fluid_setup.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_fluid_setup_F=$point_fluid_fluid_setup_F"
else
alert "point/fluid/fluid_setup.F error'd out"
fi
point_fluid_fluid_start_F=$(md5sum $1/fluid/fluid_start.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_fluid_start_F=$point_fluid_fluid_start_F"
else
alert "point/fluid/fluid_start.F error'd out"
fi
point_fluid_fluid_writeout_F=$(md5sum $1/fluid/fluid_writeout.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_fluid_writeout_F=$point_fluid_fluid_writeout_F"
else
alert "point/fluid/fluid_writeout.F error'd out"
fi
point_fluid_interp_1alloc_c=$(md5sum $1/fluid/interp_1alloc.c | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_interp_1alloc_c=$point_fluid_interp_1alloc_c"
else
alert "point/fluid/interp_1alloc.c error'd out"
fi
point_fluid_interp_c=$(md5sum $1/fluid/interp.c | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_interp_c=$point_fluid_interp_c"
else
alert "point/fluid/interp.c error'd out"
fi
point_fluid_interp_project_F=$(md5sum $1/fluid/interp_project.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_interp_project_F=$point_fluid_interp_project_F"
else
alert "point/fluid/interp_project.F error'd out"
fi
point_fluid_old_fluid_advance_F=$(md5sum $1/fluid/old/fluid_advance.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_old_fluid_advance_F=$point_fluid_old_fluid_advance_F"
else
alert "point/fluid/old/fluid_advance.F error'd out"
fi
point_fluid_old_fluid_interp_F=$(md5sum $1/fluid/old/fluid_interp.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_old_fluid_interp_F=$point_fluid_old_fluid_interp_F"
else
alert "point/fluid/old/fluid_interp.F error'd out"
fi
point_fluid_old_fluid_mod_F=$(md5sum $1/fluid/old/fluid_mod.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_old_fluid_mod_F=$point_fluid_old_fluid_mod_F"
else
alert "point/fluid/old/fluid_mod.F error'd out"
fi
point_fluid_old_fluid_restart_F=$(md5sum $1/fluid/old/fluid_restart.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_old_fluid_restart_F=$point_fluid_old_fluid_restart_F"
else
alert "point/fluid/old/fluid_restart.F error'd out"
fi
point_fluid_old_fluid_setup_F=$(md5sum $1/fluid/old/fluid_setup.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_old_fluid_setup_F=$point_fluid_old_fluid_setup_F"
else
alert "point/fluid/old/fluid_setup.F error'd out"
fi
point_fluid_old_fluid_start_F=$(md5sum $1/fluid/old/fluid_start.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_old_fluid_start_F=$point_fluid_old_fluid_start_F"
else
alert "point/fluid/old/fluid_start.F error'd out"
fi
point_fluid_old_fluid_writeout_F=$(md5sum $1/fluid/old/fluid_writeout.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_old_fluid_writeout_F=$point_fluid_old_fluid_writeout_F"
else
alert "point/fluid/old/fluid_writeout.F error'd out"
fi
point_fluid_old_interp_1alloc_c=$(md5sum $1/fluid/old/interp_1alloc.c | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_old_interp_1alloc_c=$point_fluid_old_interp_1alloc_c"
else
alert "point/fluid/old/interp_1alloc.c error'd out"
fi
point_fluid_old_interp_c=$(md5sum $1/fluid/old/interp.c | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_old_interp_c=$point_fluid_old_interp_c"
else
alert "point/fluid/old/interp.c error'd out"
fi
point_fluid_old_interp_project_F=$(md5sum $1/fluid/old/interp_project.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_fluid_old_interp_project_F=$point_fluid_old_interp_project_F"
else
alert "point/fluid/old/interp_project.F error'd out"
fi
# END POINT FLUID
# POINT HEADERS
point_headers_globals_h=$(md5sum $1/headers/globals.h | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_headers_globals_h=$point_headers_globals_h"
else
alert "point/headers/globals.h error'd out"
fi
point_headers_globals_h_old=$(md5sum $1/headers/globals.h.old | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_headers_globals_h_old=$point_headers_globals_h_old"
else
alert "point/headers/globals.h.old error'd out"
fi
point_headers_hydroparam_h=$(md5sum $1/headers/hydroparam.h | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_headers_hydroparam_h=$point_headers_hydroparam_h"
else
alert "point/headers/hydroparam.h error'd out"
fi
point_headers_readme_txt=$(md5sum $1/headers/readme.txt | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_headers_readme_txt=$point_headers_readme_txt"
else
alert "point/headers/readme.txt error'd out"
fi
point_headers_units_h=$(md5sum $1/headers/units.h | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_headers_units_h=$point_headers_units_h"
else
alert "point/headers/units.h error'd out"
fi
# END POINT HEADERS
# POINT LEGACY
point_legacy_opas_f=$(md5sum $1/legacy/opas.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_legacy_opas_f=$point_legacy_opas_f"
else
alert "point/legacy/opas.f error'd out"
fi
point_legacy_pmm_dat=$(md5sum $1/legacy/pmm.dat | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_legacy_pmm_dat=$point_legacy_pmm_dat"
else
alert "point/legacy/pmm.dat error'd out"
fi
point_legacy_README=$(md5sum $1/legacy/README | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_legacy_README=$point_legacy_README"
else
alert "point/legacy/README error'd out"
fi
# END POINT LEGACY
# POINT PARTICLES
point_particles_particle_module_f=$(md5sum $1/particles/particle_module.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_particles_particle_module_f=$point_particles_particle_module_f"
else
alert "point/particles/particle_module.f error'd out"
fi
point_particles_particle_module_f90_obsolete=$(md5sum $1/particles/particle_module.f90.obsolete | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_particles_particle_module_f90_obsolete=$point_particles_particle_module_f90_obsolete"
else
alert "point/particles/particle_module.f90.obsolete error'd out"
fi
# END POINT PARTICLES
# POINT PATCH
point_patch_ExternalRoutines_f=$(md5sum $1/patch/ExternalRoutines.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_ExternalRoutines_f=$point_patch_ExternalRoutines_f"
else
alert "point/patch/ExternalRoutines.f error'd out"
fi
point_patch_passive_f=$(md5sum $1/patch/passive.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_passive_f=$point_patch_passive_f"
else
alert "point/patch/passive.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_3dhyd_main_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/3dhyd-main.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_3dhyd_main_f=$point_patch_patch_particle_should_be_obsolete_3dhyd_main_f"
else
alert "point/patch/patch_particle_should_be_obsolete/3dhyd-main.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_boundary_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/boundary.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_boundary_f=$point_patch_patch_particle_should_be_obsolete_boundary_f"
else
alert "point/patch/patch_particle_should_be_obsolete/boundary.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_ExternalPot_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/ExternalPot.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_ExternalPot_f=$point_patch_patch_particle_should_be_obsolete_ExternalPot_f"
else
alert "point/patch/patch_particle_should_be_obsolete/ExternalPot.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_ExternalRoutines_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/ExternalRoutines.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_ExternalRoutines_f=$point_patch_patch_particle_should_be_obsolete_ExternalRoutines_f"
else
alert "point/patch/patch_particle_should_be_obsolete/ExternalRoutines.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_flux_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/flux.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_flux_f=$point_patch_patch_particle_should_be_obsolete_flux_f"
else
alert "point/patch/patch_particle_should_be_obsolete/flux.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_housekeeping_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/housekeeping.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_housekeeping_f=$point_patch_patch_particle_should_be_obsolete_housekeeping_f"
else
alert "point/patch/patch_particle_should_be_obsolete/housekeeping.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_hybrid_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/hybrid.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_hybrid_f=$point_patch_patch_particle_should_be_obsolete_hybrid_f"
else
alert "point/patch/patch_particle_should_be_obsolete/hybrid.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_io_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/io.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_io_f=$point_patch_patch_particle_should_be_obsolete_io_f"
else
alert "point/patch/patch_particle_should_be_obsolete/io.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_io_f_full=$(md5sum $1/patch/patch_particle_should_be_obsolete/io.f.full | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_io_f_full=$point_patch_patch_particle_should_be_obsolete_io_f_full"
else
alert "point/patch/patch_particle_should_be_obsolete/io.f.full error'd out"
fi
point_patch_patch_particle_should_be_obsolete_misc_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/misc.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_misc_f=$point_patch_patch_particle_should_be_obsolete_misc_f"
else
alert "point/patch/patch_particle_should_be_obsolete/misc.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_misc_f_save=$(md5sum $1/patch/patch_particle_should_be_obsolete/misc.f.save | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_misc_f_save=$point_patch_patch_particle_should_be_obsolete_misc_f_save"
else
alert "point/patch/patch_particle_should_be_obsolete/misc.f.save error'd out"
fi
point_patch_patch_particle_should_be_obsolete_particle_module_cart_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.cart.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_particle_module_cart_f=$point_patch_patch_particle_should_be_obsolete_particle_module_cart_f"
else
alert "point/patch/patch_particle_should_be_obsolete/particle_module.cart.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_particle_module_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_particle_module_f=$point_patch_patch_particle_should_be_obsolete_particle_module_f"
else
alert "point/patch/patch_particle_should_be_obsolete/particle_module.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_particle_module_f_full=$(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f.full | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_particle_module_f_full=$point_patch_patch_particle_should_be_obsolete_particle_module_f_full"
else
alert "point/patch/patch_particle_should_be_obsolete/particle_module.f.full error'd out"
fi
point_patch_patch_particle_should_be_obsolete_particle_module_f_jn=$(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f.jn | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_particle_module_f_jn=$point_patch_patch_particle_should_be_obsolete_particle_module_f_jn"
else
alert "point/patch/patch_particle_should_be_obsolete/particle_module.f.jn error'd out"
fi
point_patch_patch_particle_should_be_obsolete_particle_module_fomp=$(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.fomp | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_particle_module_fomp=$point_patch_patch_particle_should_be_obsolete_particle_module_fomp"
else
alert "point/patch/patch_particle_should_be_obsolete/particle_module.fomp error'd out"
fi
point_patch_patch_particle_should_be_obsolete_particle_module_f_omp=$(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f.omp | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_particle_module_f_omp=$point_patch_patch_particle_should_be_obsolete_particle_module_f_omp"
else
alert "point/patch/patch_particle_should_be_obsolete/particle_module.f.omp error'd out"
fi
point_patch_patch_particle_should_be_obsolete_particle_module_f_save=$(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f.save | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_particle_module_f_save=$point_patch_patch_particle_should_be_obsolete_particle_module_f_save"
else
alert "point/patch/patch_particle_should_be_obsolete/particle_module.f.save error'd out"
fi
point_patch_patch_particle_should_be_obsolete_particle_module_f_static=$(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f.static | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_particle_module_f_static=$point_patch_patch_particle_should_be_obsolete_particle_module_f_static"
else
alert "point/patch/patch_particle_should_be_obsolete/particle_module.f.static error'd out"
fi
point_patch_patch_particle_should_be_obsolete_particle_module_f_working=$(md5sum $1/patch/patch_particle_should_be_obsolete/particle_module.f.working | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_particle_module_f_working=$point_patch_patch_particle_should_be_obsolete_particle_module_f_working"
else
alert "point/patch/patch_particle_should_be_obsolete/particle_module.f.working error'd out"
fi
point_patch_patch_particle_should_be_obsolete_passive_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/passive.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_passive_f=$point_patch_patch_particle_should_be_obsolete_passive_f"
else
alert "point/patch/patch_particle_should_be_obsolete/passive.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_pot3_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/pot3.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_pot3_f=$point_patch_patch_particle_should_be_obsolete_pot3_f"
else
alert "point/patch/patch_particle_should_be_obsolete/pot3.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_RadTran_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/RadTran.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_RadTran_f=$point_patch_patch_particle_should_be_obsolete_RadTran_f"
else
alert "point/patch/patch_particle_should_be_obsolete/RadTran.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_RadTran_f_save=$(md5sum $1/patch/patch_particle_should_be_obsolete/RadTran.f.save | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_RadTran_f_save=$point_patch_patch_particle_should_be_obsolete_RadTran_f_save"
else
alert "point/patch/patch_particle_should_be_obsolete/RadTran.f.save error'd out"
fi
point_patch_patch_particle_should_be_obsolete_README=$(md5sum $1/patch/patch_particle_should_be_obsolete/README | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_README=$point_patch_patch_particle_should_be_obsolete_README"
else
alert "point/patch/patch_particle_should_be_obsolete/README error'd out"
fi
point_patch_patch_particle_should_be_obsolete_source_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/source.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_source_f=$point_patch_patch_particle_should_be_obsolete_source_f"
else
alert "point/patch/patch_particle_should_be_obsolete/source.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_state_f=$(md5sum $1/patch/patch_particle_should_be_obsolete/state.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_state_f=$point_patch_patch_particle_should_be_obsolete_state_f"
else
alert "point/patch/patch_particle_should_be_obsolete/state.f error'd out"
fi
point_patch_patch_particle_should_be_obsolete_tcart=$(md5sum $1/patch/patch_particle_should_be_obsolete/tcart | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_tcart=$point_patch_patch_particle_should_be_obsolete_tcart"
else
alert "point/patch/patch_particle_should_be_obsolete/tcart error'd out"
fi
point_patch_patch_particle_should_be_obsolete_wiggle_F=$(md5sum $1/patch/patch_particle_should_be_obsolete/wiggle.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_patch_patch_particle_should_be_obsolete_wiggle_F=$point_patch_patch_particle_should_be_obsolete_wiggle_F"
else
alert "point/patch/patch_particle_should_be_obsolete/wiggle.F error'd out"
fi
# END POINT PATCH
# POINT POT
point_pot_blktri_f=$(md5sum $1/pot/blktri.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_pot_blktri_f=$point_pot_blktri_f"
else
alert "point/pot/blktri.f error'd out"
fi
point_pot_boundary_f=$(md5sum $1/pot/boundary.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_pot_boundary_f=$point_pot_boundary_f"
else
alert "point/pot/boundary.f error'd out"
fi
point_pot_ExternalPot_f=$(md5sum $1/pot/ExternalPot.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_pot_ExternalPot_f=$point_pot_ExternalPot_f"
else
alert "point/pot/ExternalPot.f error'd out"
fi
point_pot_ExternalPot_original2_f=$(md5sum $1/pot/ExternalPot.original2.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_pot_ExternalPot_original2_f=$point_pot_ExternalPot_original2_f"
else
alert "point/pot/ExternalPot.original2.f error'd out"
fi
point_pot_ExternalPot_original_f=$(md5sum $1/pot/ExternalPot.original.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_pot_ExternalPot_original_f=$point_pot_ExternalPot_original_f"
else
alert "point/pot/ExternalPot.original.f error'd out"
fi
point_pot_fft_f=$(md5sum $1/pot/fft.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_pot_fft_f=$point_pot_fft_f"
else
alert "point/pot/fft.f error'd out"
fi
point_pot_pot3_f=$(md5sum $1/pot/pot3.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_pot_pot3_f=$point_pot_pot3_f"
else
alert "point/pot/pot3.f error'd out"
fi
point_pot_wiggle_F=$(md5sum $1/pot/wiggle.F | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_pot_wiggle_F=$point_pot_wiggle_F"
else
alert "point/pot/wiggle.F error'd out"
fi
# END POINT POT
# POINT RADHYDRO
point_radhydro_3dhyd_main_diff=$(md5sum $1/radhydro/3dhyd-main.diff | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_3dhyd_main_diff=$point_radhydro_3dhyd_main_diff"
else
alert "point/radhydro/3dhyd-main.diff error'd out"
fi
point_radhydro_3dhyd_main_f=$(md5sum $1/radhydro/3dhyd-main.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_3dhyd_main_f=$point_radhydro_3dhyd_main_f"
else
alert "point/radhydro/3dhyd-main.f error'd out"
fi
point_radhydro_avisc_f=$(md5sum $1/radhydro/avisc.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_avisc_f=$point_radhydro_avisc_f"
else
alert "point/radhydro/avisc.f error'd out"
fi
point_radhydro_CoolingPrescriptions_f=$(md5sum $1/radhydro/CoolingPrescriptions.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_CoolingPrescriptions_f=$point_radhydro_CoolingPrescriptions_f"
else
alert "point/radhydro/CoolingPrescriptions.f error'd out"
fi
point_radhydro_diff_txt=$(md5sum $1/radhydro/diff.txt | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_diff_txt=$point_radhydro_diff_txt"
else
alert "point/radhydro/diff.txt error'd out"
fi
point_radhydro_ExternalRoutines_f=$(md5sum $1/radhydro/ExternalRoutines.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_ExternalRoutines_f=$point_radhydro_ExternalRoutines_f"
else
alert "point/radhydro/ExternalRoutines.f error'd out"
fi
point_radhydro_flux_f=$(md5sum $1/radhydro/flux.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_flux_f=$point_radhydro_flux_f"
else
alert "point/radhydro/flux.f error'd out"
fi
point_radhydro_housekeeping_f=$(md5sum $1/radhydro/housekeeping.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_housekeeping_f=$point_radhydro_housekeeping_f"
else
alert "point/radhydro/housekeeping.f error'd out"
fi
point_radhydro_hybrid_f=$(md5sum $1/radhydro/hybrid.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_hybrid_f=$point_radhydro_hybrid_f"
else
alert "point/radhydro/hybrid.f error'd out"
fi
point_radhydro_hybrid_old_nosubcycle_f=$(md5sum $1/radhydro/hybrid.old.nosubcycle.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_hybrid_old_nosubcycle_f=$point_radhydro_hybrid_old_nosubcycle_f"
else
alert "point/radhydro/hybrid.old.nosubcycle.f error'd out"
fi
point_radhydro_io_diff=$(md5sum $1/radhydro/io.diff | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_io_diff=$point_radhydro_io_diff"
else
alert "point/radhydro/io.diff error'd out"
fi
point_radhydro_io_f=$(md5sum $1/radhydro/io.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_io_f=$point_radhydro_io_f"
else
alert "point/radhydro/io.f error'd out"
fi
point_radhydro_misc_f=$(md5sum $1/radhydro/misc.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_misc_f=$point_radhydro_misc_f"
else
alert "point/radhydro/misc.f error'd out"
fi
point_radhydro_orig_3dhyd_main_f=$(md5sum $1/radhydro/orig_3dhyd-main.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_orig_3dhyd_main_f=$point_radhydro_orig_3dhyd_main_f"
else
alert "point/radhydro/orig_3dhyd-main.f error'd out"
fi
point_radhydro_passive_f=$(md5sum $1/radhydro/passive.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_passive_f=$point_radhydro_passive_f"
else
alert "point/radhydro/passive.f error'd out"
fi
point_radhydro_rad_f=$(md5sum $1/radhydro/rad.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_rad_f=$point_radhydro_rad_f"
else
alert "point/radhydro/rad.f error'd out"
fi
point_radhydro_RadTran_f=$(md5sum $1/radhydro/RadTran.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_RadTran_f=$point_radhydro_RadTran_f"
else
alert "point/radhydro/RadTran.f error'd out"
fi
point_radhydro_source_f=$(md5sum $1/radhydro/source.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_source_f=$point_radhydro_source_f"
else
alert "point/radhydro/source.f error'd out"
fi
point_radhydro_w_3dhyd_main_f=$(md5sum $1/radhydro/w_3dhyd-main.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_w_3dhyd_main_f=$point_radhydro_w_3dhyd_main_f"
else
alert "point/radhydro/w_3dhyd-main.f error'd out"
fi
point_radhydro_w_io_f=$(md5sum $1/radhydro/w_io.f | cut --delimiter=" " -f1 )
if [ "$?" ==  0 ]; then
((__md5_files_temp++))
logvv "point_radhydro_w_io_f=$point_radhydro_w_io_f"
else
alert "point/radhydro/w_io.f error'd out"
fi
# END POINT RADHYDRO
fi
unset __md5_files_temp
}
## ! MD5-SUM ##

#### ! END SCRIPTS SECTION #####



#### Gah-NOPE ####
#who really does any work around here anyway
main "$@"
