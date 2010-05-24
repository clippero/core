/*
 * $Id$
 */

/*
 * Copyright 2010 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://www.harbour-project.org
 *
 * See COPYING for licensing terms.
 */

FUNCTION hbmk2_plugin_moc( cState, hbmk2 )
   LOCAL cMOC_BIN

   LOCAL tmp

   SWITCH cState
   CASE "pre_all"

      FOR EACH tmp IN hbmk2[ "params" ]
         hbmk2_OutStd( hbmk2, hb_StrFormat( "Parameter #%1$s: '%2$s'", hb_ntos( tmp:__enumIndex() ), tmp ) )
      NEXT

      hbmk2_AddInput_C( hbmk2, "hello.c" )
      EXIT

   CASE "pre_c"

      cMOC_BIN := GetEnv( "MOC_BIN" )
      IF Empty( cMOC_BIN )
         IF Empty( GetEnv( "HB_QT_MOC_BIN" ) )
            IF hbmk2[ "cPLAT" ] == "win"
               cMOC_BIN := GetEnv( "HB_WITH_QT" ) + "\..\bin\moc.exe"
               IF ! hb_FileExists( cMOC_BIN )
                  hbmk2_OutErr( hbmk2, "HB_WITH_QT points to incomplete QT installation. moc executable not found." )
                  RETURN NIL
               ENDIF
            ELSE
               cMOC_BIN := hbmk2_FindInPath( "moc", "/opt/qtsdk/qt/bin" )
               IF Empty( cMOC_BIN )
                  cMOC_BIN := hbmk2_FindInPath( "moc", "/opt/qtsdk/qt/bin" )
                  IF Empty( cMOC_BIN )
                     hbmk2_OutErr( hbmk2, "HB_QT_MOC_BIN not set, could not autodetect" )
                     RETURN NIL
                  ENDIF
               ENDIF
            ENDIF
            hbmk2_OutStd( hbmk2, "Using QT 'moc' executable: " + cMOC_BIN + " (autodetected)" )
         ELSE
            IF hb_FileExists( GetEnv( "HB_QT_MOC_BIN" ) )
               cMOC_BIN := GetEnv( "HB_QT_MOC_BIN" )
               hbmk2_OutStd( hbmk2, "Using QT 'moc' executable: " + cMOC_BIN )
            ELSE
               hbmk2_OutErr( hbmk2, "HB_QT_MOC_BIN points to non-existent file. Make sure to set it to full path and filename of moc executable." )
               RETURN NIL
            ENDIF
         ENDIF
      ENDIF

      hbmk2[ "vars" ][ "MOC_BIN" ] := cMOC_BIN

      EXIT
   CASE "post_all"
      hbmk2_OutStd( hbmk2, "POST_ALL: " + hbmk2[ "vars" ][ "MOC_BIN" ] )
   OTHERWISE
      IF hbmk2[ "lTRACE" ]
         hbmk2_OutStd( hbmk2, "@@ Entered plugin: " + cState )
      ENDIF
   ENDSWITCH

   RETURN NIL
