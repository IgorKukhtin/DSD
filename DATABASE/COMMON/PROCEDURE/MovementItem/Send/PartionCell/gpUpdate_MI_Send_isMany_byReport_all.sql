-- Function: gpUpdate_MI_Send_isMany_byReport_all()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_isMany_byReport_all (Integer, Integer,Integer,Integer, Integer, TDateTime
                                                             ,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer,Integer
                                                             ,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean
                                                             ,TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_isMany_byReport_all(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId        Integer   , -- Ключ объекта <Элемент документа> 
    IN inUnitId                Integer  , --
    IN inGoodsId               Integer  ,
    IN inGoodsKindId           Integer  ,
    IN inPartionGoodsDate      TDateTime, --

    IN inPartionCellId_1          Integer   , --
    IN inPartionCellId_2          Integer   , --
    IN inPartionCellId_3          Integer   , --
    IN inPartionCellId_4          Integer   , --
    IN inPartionCellId_5          Integer   , --
    IN inPartionCellId_6          Integer   , --
    IN inPartionCellId_7          Integer   , --
    IN inPartionCellId_8          Integer   , --
    IN inPartionCellId_9          Integer   , --
    IN inPartionCellId_10         Integer   , --
    IN inPartionCellId_11         Integer   , --
    IN inPartionCellId_12         Integer   , --
    IN inPartionCellId_13         Integer   , --
    IN inPartionCellId_14         Integer   , --
    IN inPartionCellId_15         Integer   , --
    IN inPartionCellId_16         Integer   , --
    IN inPartionCellId_17         Integer   , --
    IN inPartionCellId_18         Integer   , --
    IN inPartionCellId_19         Integer   , --
    IN inPartionCellId_20         Integer   , --
    IN inPartionCellId_21         Integer   , --
    IN inPartionCellId_22         Integer   , --
     
    IN inisMany_1                 Boolean   , --
    IN inisMany_2                 Boolean   , --
    IN inisMany_3                 Boolean   , --
    IN inisMany_4                 Boolean   , --
    IN inisMany_5                 Boolean   , --
    IN inisMany_6                 Boolean   , --
    IN inisMany_7                 Boolean   , --
    IN inisMany_8                 Boolean   , --
    IN inisMany_9                 Boolean   , --
    IN inisMany_10                Boolean   , --
    IN inisMany_11                Boolean   , --
    IN inisMany_12                Boolean   , --
    IN inisMany_13                Boolean   , --
    IN inisMany_14                Boolean   , --
    IN inisMany_15                Boolean   , --
    IN inisMany_16                Boolean   , --
    IN inisMany_17                Boolean   , --
    IN inisMany_18                Boolean   , --
    IN inisMany_19                Boolean   , --
    IN inisMany_20                Boolean   , --
    IN inisMany_21                Boolean   , --
    IN inisMany_22                Boolean   , -- 

    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
           vbDescId   Integer;
           vbIsWeighing Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Send_isMany_byReport());


     --Ячейка 1
     IF COALESCE (inPartionCellId_1,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 1                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_1  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_1         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 2
     IF COALESCE (inPartionCellId_2,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 2                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_2  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_2         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 3
     IF COALESCE (inPartionCellId_3,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 3                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_3  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_3         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 4
     IF COALESCE (inPartionCellId_4,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 4                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_4  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_4         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 5
     IF COALESCE (inPartionCellId_1,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 5                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_5  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_5         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 6
     IF COALESCE (inPartionCellId_6,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 6                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_6  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_6         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 7
     IF COALESCE (inPartionCellId_7,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 7                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_7  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_7         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 8
     IF COALESCE (inPartionCellId_8,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 8                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_8  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_8         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 9
     IF COALESCE (inPartionCellId_9,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 9                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_9  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_9         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 10
     IF COALESCE (inPartionCellId_10,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 10                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_10  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_10         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 11
     IF COALESCE (inPartionCellId_11,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 11                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_11  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_11         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 12
     IF COALESCE (inPartionCellId_12,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 12                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_12  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_12         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 13
     IF COALESCE (inPartionCellId_13,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 13                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_13  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_13         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 14
     IF COALESCE (inPartionCellId_14,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 14                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_14  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_14         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 15
     IF COALESCE (inPartionCellId_15,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 15                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_15  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_15         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 16
     IF COALESCE (inPartionCellId_16,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 16                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_16  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_16         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 17
     IF COALESCE (inPartionCellId_17,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 17                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_17  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_17         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 18
     IF COALESCE (inPartionCellId_18,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 18                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_18  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_18         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 19
     IF COALESCE (inPartionCellId_19,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 19                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_19  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_19         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 20
     IF COALESCE (inPartionCellId_20,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 20                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_20  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_20         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 21
     IF COALESCE (inPartionCellId_21,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 21                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_21  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_21         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 

     --Ячейка 22
     IF COALESCE (inPartionCellId_22,0) <> 0
     THEN
         --
         PERFORM gpUpdate_MI_Send_isMany_byReport(inMovementId        := inMovementId       ::Integer   
                                                , inMovementItemId    := inMovementItemId   ::Integer   
                                                , inPartionCellNum    := 22                  ::Integer   
                                                , inPartionCellId     := inPartionCellId_22  ::Integer   
                                                , inUnitId            := inUnitId           ::Integer
                                                , inGoodsId           := inGoodsId          ::Integer
                                                , inGoodsKindId       := inGoodsKindId      ::Integer
                                                , inPartionGoodsDate  := inPartionGoodsDate ::TDateTime
                                                , inisMany            := inisMany_22         ::Boolean  
                                                , inSession           := inSession          ::TVarChar
                                                );
     END IF; 



        
     if vbUserId = 9457 
     then
         RAISE EXCEPTION 'Test. Ok';
     end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.05.25         *
*/

-- тест
--