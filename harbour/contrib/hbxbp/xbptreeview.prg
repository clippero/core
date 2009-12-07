/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * Source file for the Xbp*Classes
 *
 * Copyright 2009 Pritpal Bedi <pritpal@vouchcac.com>
 * http://www.harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*
 *                                EkOnkar
 *                          ( The LORD is ONE )
 *
 *                  Xbase++ xbpTreeView compatible Class
 *
 *                  Pritpal Bedi <pritpal@vouchcac.com>
 *                               20Jun2009
 */
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"

#include "xbp.ch"
#include "appevent.ch"

/*----------------------------------------------------------------------*/

CLASS XbpTreeView  INHERIT  XbpWindow, XbpDataRef

   DATA     alwaysShowSelection                   INIT .F.
   DATA     hasButtons                            INIT .F.
   DATA     hasLines                              INIT .F.

   DATA     aItems                                INIT {}

   DATA     oRootItem
   ACCESS   rootItem()                            INLINE ::oRootItem

   METHOD   new()
   METHOD   create()
   METHOD   configure()
   METHOD   destroy()
   METHOD   handleEvent()
   METHOD   exeBlock()
   METHOD   setStyle()

   METHOD   itemFromPos( aPos )

   DATA     sl_itemCollapsed
   ACCESS   itemCollapsed                         INLINE ::sl_itemCollapsed
   ASSIGN   itemCollapsed( bBlock )               INLINE ::sl_itemCollapsed := bBlock

   DATA     sl_itemExpanded
   ACCESS   itemExpanded                          INLINE ::sl_itemExpanded
   ASSIGN   itemExpanded( bBlock )                INLINE ::sl_itemExpanded := bBlock

   DATA     sl_itemMarked
   ACCESS   itemMarked                            INLINE ::sl_itemMarked
   ASSIGN   itemMarked( bBlock )                  INLINE ::sl_itemMarked := bBlock

   DATA     oItemSelected
   DATA     sl_itemSelected
   ACCESS   itemSelected                          INLINE ::sl_itemSelected
   ASSIGN   itemSelected( bBlock )                INLINE ::sl_itemSelected := bBlock

   DATA     hParentSelected
   DATA     hItemSelected
   DATA     textParentSelected                    INIT ""
   DATA     textItemSelected                      INIT ""

   #if 0
   METHOD   setColorFG( nRGB )                    INLINE WVG_TreeView_SetTextColor( ::hWnd, nRGB )
   METHOD   setColorBG( nRGB )                    INLINE WVG_TreeView_SetBkColor( ::hWnd, nRGB )
   METHOD   setColorLines( nRGB )                 INLINE WVG_TreeView_SetLineColor( ::hWnd, nRGB )


   METHOD   showExpanded( lExpanded, nLevels )    INLINE Wvg_TreeView_ShowExpanded( ::hWnd, ;
                                                         IF( hb_isNil( lExpanded ), .f., lExpanded ), nLevels )
   #endif
   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD XbpTreeView:new( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::xbpWindow:init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD XbpTreeView:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   LOCAL oW

   ::xbpWindow:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::oWidget := QTreeWidget():new( ::pParent )
   ::oWidget:setColumnCount( 1 )
   ::oWidget:setHeaderHidden( .t. )


   #if 0
   IF ::alwaysShowSelection
      ::style += TVS_SHOWSELALWAYS
   ENDIF
   IF ::hasButtons
      ::style += TVS_HASBUTTONS
   ENDIF
   IF ::hasLines
      ::style += TVS_HASLINES + TVS_LINESATROOT
   ENDIF
   #endif

   ::oRootItem          := XbpTreeViewItem():New()
   ::oRootItem:hTree    := ::oWidget
   ::oRootItem:oXbpTree := self

   oW                   := QTreeWidgetItem()
   oW:pPtr              := ::oWidget:invisibleRootItem()
   ::oRootItem:oWidget  := oW

   /* Window Events */
   ::oWidget:installEventFilter( SetEventFilter() )
   ::connectEvent( ::pWidget, QEvent_ContextMenu, {|o,e| ::grabEvent( QEvent_ContextMenu, e, o ) } )

   //::connect( ::pWidget, "currentItemChanged(QTWItem)" , {|o,p1,p2| ::exeBlock(  1, p1, p2, o ) } )
   //::connect( ::pWidget, "itemActivated(QTWItem)"      , {|o,p1,p2| ::exeBlock(  2, p1, p2, o ) } )
   //::connect( ::pWidget, "itemChanged(QTWItem)"        , {|o,p1,p2| ::exeBlock(  3, p1, p2, o ) } )
   ::connect( ::pWidget, "itemClicked(QTWItem)"        , {|o,p1,p2| ::exeBlock(  4, p1, p2, o ) } )
   ::connect( ::pWidget, "itemCollapsed(QTWItem)"      , {|o,p1,p2| ::exeBlock(  5, p1, p2, o ) } )
   ::connect( ::pWidget, "itemDoubleClicked(QTWItem)"  , {|o,p1,p2| ::exeBlock(  6, p1, p2, o ) } )
   //::connect( ::pWidget, "itemEntered(QTWItem)"        , {|o,p1,p2| ::exeBlock(  7, p1, p2, o ) } )
   ::connect( ::pWidget, "itemExpanded(QTWItem)"       , {|o,p1,p2| ::exeBlock(  8, p1, p2, o ) } )
   //::connect( ::pWidget, "itemPressed(QTWItem)"        , {|o,p1,p2| ::exeBlock(  9, p1, p2, o ) } )
   //::connect( ::pWidget, "itemSelectionChanged()"      , {|o,p1,p2| ::exeBlock( 10, p1, p2, o ) } )

   ::setPosAndSize()
   IF ::visible
      ::show()
   ENDIF
   ::oParent:AddChild( SELF )
   RETURN Self

/*----------------------------------------------------------------------*/

METHOD XbpTreeView:ExeBlock( nMsg, p1, p2 )
   LOCAL oItem, n

   HB_SYMBOL_UNUSED( nMsg )
   HB_SYMBOL_UNUSED( p1   )
   HB_SYMBOL_UNUSED( p2   )

   IF hb_isPointer( p1 )
      IF ( n := ascan( ::aItems, {|o| o:qPointer == p1 } ) ) > 0
         oItem := ::aItems[ n ]
      ENDIF
   ENDIF

   DO CASE
   CASE nMsg == 1              // "currentItemChanged(QTWItem)"
   CASE nMsg == 2              // "itemActivated(QTWItem)"
   CASE nMsg == 3              // "itemChanged(QTWItem)"
   CASE nMsg == 4              // "itemClicked(QTWItem)"
      IF hb_isBlock( ::sl_itemMarked )
         eval( ::sl_itemMarked, oItem, {0,0,0,0}, self )
      ENDIF
   CASE nMsg == 5              // "itemCollapsed(QTWItem)"
      IF hb_isBlock( ::sl_itemCollapsed )
         eval( ::sl_itemCollapsed, oItem, {0,0,0,0}, self )
      ENDIF
   CASE nMsg == 6              // "itemDoubleClicked(QTWItem)"
      IF hb_isBlock( ::sl_itemSelected )
         eval( ::sl_itemSelected, oItem, {0,0,0,0}, self )
      ENDIF
   CASE nMsg == 7              // "itemEntered(QTWItem)"
      //::oWidget:setToolTip( oItem:caption )
   CASE nMsg == 8              // "itemExpanded(QTWItem)"
      IF hb_isBlock( ::sl_itemExpanded )
         eval( ::sl_itemExpanded, oItem, {0,0,0,0}, self )
      ENDIF
   CASE nMsg == 9              // "itemPressed(QTWItem)"
   CASE nMsg == 10             // "itemSelectionChanged()"

   ENDCASE

   RETURN .f.

/*----------------------------------------------------------------------*/

METHOD XbpTreeView:handleEvent( nEvent, mp1, mp2 )

   HB_SYMBOL_UNUSED( nEvent )
   HB_SYMBOL_UNUSED( mp1    )
   HB_SYMBOL_UNUSED( mp2    )

   RETURN HBXBP_EVENT_UNHANDLED

/*----------------------------------------------------------------------*/

METHOD XbpTreeView:destroy()
   LOCAL i

   ::disconnect()

   FOR i := len( ::aItems ) TO 1 step -1
      aeval( ::aItems[ i ]:aChilds, {|e,j| e := e, ::aItems[ i ]:aChilds[ j ] := NIL } )
      ::aItems[ i ]:oWidget:pPtr := 0
   NEXT
   ::aItems := NIL

   ::sl_itemCollapsed        := NIL
   ::sl_itemExpanded         := NIL
   ::sl_itemMarked           := NIL
   ::oItemSelected           := NIL
   ::sl_itemSelected         := NIL
   ::hParentSelected         := NIL
   ::hItemSelected           := NIL
   ::textParentSelected      := NIL
   ::textItemSelected        := NIL

   ::xbpWindow:destroy()

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD XbpTreeView:configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::Initialize( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD XbpTreeView:itemFromPos( aPos )

   HB_SYMBOL_UNUSED( aPos )

   RETURN Self

/*----------------------------------------------------------------------*/
#if 0
METHOD XbpTreeView:itemCollapsed( xParam )

   IF hb_isBlock( xParam ) .or. ( xParam == NIL )
      ::sl_paint := xParam
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD XbpTreeView:itemExpanded( xParam )

   IF hb_isBlock( xParam ) .or. ( xParam == NIL )
      ::sl_itemExpanded := xParam
   ENDIF

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD XbpTreeView:itemMarked( xParam )

   IF hb_isBlock( xParam ) .or. ( xParam == NIL )
      ::sl_itemMarked := xParam
   ENDIF

   RETURN Self
#endif
/*----------------------------------------------------------------------*/
#if 0
METHOD XbpTreeView:itemSelected( xParam )

   IF hb_isBlock( xParam ) .or. ( xParam == NIL )
      ::sl_itemSelected := xParam
   ENDIF

   RETURN Self
#endif
/*----------------------------------------------------------------------*/
/*                      Class XbpTreeViewItem                           */
/*----------------------------------------------------------------------*/

CLASS XbpTreeViewItem  INHERIT  XbpDataRef

   DATA     oWidget
   ACCESS   pWidget                               INLINE IF( hb_isObject( ::oWidget ), ::oWidget:pPtr, NIL )

   DATA     caption                               INIT ""
   DATA     dllName                               INIT NIL
   DATA     expandedImage                         INIT -1
   DATA     image                                 INIT -1
   DATA     markedImage                           INIT -1

   DATA     xValue                                             // To be returned by get/set methods

   DATA     hTree
   DATA     hItem
   DATA     oParent
   DATA     oXbpTree
   DATA     qPointer

   DATA     aChilds                               INIT {}

   METHOD   new()
   METHOD   create()
   METHOD   configure()
   METHOD   destroy()

   METHOD   expand( lExpand )                     INLINE   ::oWidget:setExpanded( lExpand )
   METHOD   isExpanded()                          INLINE   ::oWidget:isExpanded()

   METHOD   setCaption( cCaption )                INLINE   ::oWidget:setText( 0, cCaption )
   METHOD   setImage( xIcon )
   METHOD   setExpandedImage( nResIdoBitmap )
   METHOD   setMarkedImage( nResIdoBitmap )

   METHOD   addItem()
   METHOD   delItem( oItem )
   METHOD   getChildItems()
   METHOD   getParentItem()
   METHOD   insItem()

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD XbpTreeViewItem:addItem( xItem, xNormalImage, xMarkedImage, xExpandedImage, cDllName, xValue )
   Local oItem

   HB_SYMBOL_UNUSED( cDllName )

   IF valtype( xItem ) == 'C'
      oItem := XbpTreeViewItem():New()
      oItem:caption := xItem
      oItem:oWidget := QTreeWidgetItem():new()
      oItem:oWidget:setText( 0, oItem:caption )
      oItem:qPointer := HBQT_QTPTR_FROM_GCPOINTER( oItem:oWidget:pPtr )
   ELSE
      oItem := xItem   // aNode
   ENDIF

   oItem:oParent := self
   oItem:oXbpTree := oItem:oParent:oXbpTree

   IF xNormalImage <> NIL
      oItem:image := xNormalImage
   ENDIF
   IF xMarkedImage <> NIL
      oItem:markedImage := xMarkedImage
   ENDIF
   IF xExpandedImage <> NIL
      oItem:expandedImage := xExpandedImage
   ENDIF
   IF xValue <> NIL
      oItem:xValue := xValue
   ENDIF

   ::oWidget:addChild( oItem:oWidget:pPtr )

   aadd( ::aChilds, oItem )
   aadd( oItem:aChilds, oItem )
   aadd( oItem:oXbpTree:aItems, oItem )

   RETURN oItem

/*----------------------------------------------------------------------*/

METHOD XbpTreeViewItem:new()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD XbpTreeViewItem:create()

   ::oWidget := QTreeWidgetItem():new()
   ::oWidget:setText( 0,::caption )

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD XbpTreeViewItem:configure()

   RETURN Self

/*----------------------------------------------------------------------*/

METHOD XbpTreeViewItem:destroy()
   LOCAL i

   FOR i := 1 TO len( ::aChilds )
      ::aChilds[ i ]:pPtr := 0
      ::aChilds[ i ]:pPtr := NIL
   NEXT

   ::oItem:pPtr := 0
   ::oItem:pPtr := Nil

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD XbpTreeViewItem:setExpandedImage( nResIdoBitmap )

   HB_SYMBOL_UNUSED( nResIdoBitmap )

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD XbpTreeViewItem:setImage( xIcon )

   ::oWidget:setIcon( 0, xIcon )

   RETURN self

/*----------------------------------------------------------------------*/

METHOD XbpTreeViewItem:setMarkedImage( nResIdoBitmap )

   HB_SYMBOL_UNUSED( nResIdoBitmap )

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD XbpTreeViewItem:delItem( oItem )
   LOCAL n

   IF ( n := ascan( ::aChilds, {|o| o:caption == oItem:caption  } ) ) > 0
      ::oWidget:removeChild( ::aChilds[ n ]:oWidget:pPtr )
      ::aChilds[ n ]:oWidget:pPtr := 0
      adel( ::aChilds, n ) ; asize( ::aChilds, len( ::aChilds )-1 )
   ENDIF

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD XbpTreeViewItem:getChildItems()

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD XbpTreeViewItem:getParentItem()

   RETURN NIL

/*----------------------------------------------------------------------*/

METHOD XbpTreeViewItem:insItem()

   RETURN NIL

/*----------------------------------------------------------------------*/
/* Another approach - in the making
 */
METHOD XbpTreeView:setStyle()
   #if 0
   LOCAL oS

   oS := XbpStyle():new()
   oS:xbpPart  := "XbpTreeView"
   oS:qtWidget := "QTreeWidget"
   oS:colorFG  := "white"
   oS:colorBG  := "blue"
   oS:create()
   ::oWidget:setStyleSheet( oS:style )
   #else
   LOCAL s := "", txt_:={}

   aadd( txt_, 'QTreeView {                                                                                      ' )
   aadd( txt_, '     alternate-background-color: yellow;                                                         ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView {                                                                                     ' )
   aadd( txt_, '     show-decoration-selected: 1;                                                                ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::item {                                                                               ' )
   aadd( txt_, '      border: 1px solid #d9d9d9;                                                                 ' )
   aadd( txt_, '     border-top-color: transparent;                                                              ' )
   aadd( txt_, '     border-bottom-color: transparent;                                                           ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::item:hover {                                                                         ' )
   aadd( txt_, '     background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #e7effd, stop: 1 #cbdaf1);  ' )
   aadd( txt_, '     border: 1px solid #bfcde4;                                                                  ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::item:selected {                                                                      ' )
   aadd( txt_, '     border: 1px solid #567dbc;                                                                  ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::item:selected:active{                                                                ' )
   aadd( txt_, '     background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #6ea1f1, stop: 1 #567dbc);  ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::item:selected:!active {                                                              ' )
   aadd( txt_, '     background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #6b9be8, stop: 1 #577fbf);  ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::branch {                                                                             ' )
   aadd( txt_, '         background: palette(base);                                                              ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::branch:has-siblings:!adjoins-item {                                                  ' )
   aadd( txt_, '         background: cyan;                                                                       ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::branch:has-siblings:adjoins-item {                                                   ' )
   aadd( txt_, '         background: red;                                                                        ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::branch:!has-children:!has-siblings:adjoins-item {                                    ' )
   aadd( txt_, '         background: blue;                                                                       ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::branch:closed:has-children:has-siblings {                                            ' )
   aadd( txt_, '         background: pink;                                                                       ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::branch:has-children:!has-siblings:closed {                                           ' )
   aadd( txt_, '         background: gray;                                                                       ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::branch:open:has-children:has-siblings {                                              ' )
   aadd( txt_, '         background: magenta;                                                                    ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::branch:open:has-children:!has-siblings {                                             ' )
   aadd( txt_, '         background: green;                                                                      ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, 'vline.png   branch-more.png   branch-end.png   branch-closed.png   branch-open.png               ' )
   aadd( txt_, ' QTreeView::branch:has-siblings:!adjoins-item {                                                  ' )
   aadd( txt_, '     border-image: url(vline.png) 0;                                                             ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::branch:has-siblings:adjoins-item {                                                   ' )
   aadd( txt_, '     border-image: url(branch-more.png) 0;                                                       ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::branch:!has-children:!has-siblings:adjoins-item {                                    ' )
   aadd( txt_, '     border-image: url(branch-end.png) 0;                                                        ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::branch:has-children:!has-siblings:closed,                                            ' )
   aadd( txt_, ' QTreeView::branch:closed:has-children:has-siblings {                                            ' )
   aadd( txt_, '         border-image: none;                                                                     ' )
   aadd( txt_, '         image: url(branch-closed.png);                                                          ' )
   aadd( txt_, ' }                                                                                               ' )
   aadd( txt_, '                                                                                                 ' )
   aadd( txt_, ' QTreeView::branch:open:has-children:!has-siblings,                                              ' )
   aadd( txt_, ' QTreeView::branch:open:has-children:has-siblings  {                                             ' )
   aadd( txt_, '         border-image: none;                                                                     ' )
   aadd( txt_, '         image: url(branch-open.png);                                                            ' )
   aadd( txt_, ' } ' )

   aeval( txt_, {|e| s += e + chr( 13 )+chr( 10 ) } )

   ::oWidget:setStyleSheet( s )

   #endif
   RETURN nil

/*----------------------------------------------------------------------*/
