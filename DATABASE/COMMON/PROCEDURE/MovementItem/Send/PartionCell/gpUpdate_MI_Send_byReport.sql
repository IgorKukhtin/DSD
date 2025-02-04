-- Function: gpUpdate_MI_Send_byReport()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_byReport (Integer, TDateTime,TDateTime, Integer, Integer, Integer, Integer, TDateTime, Boolean
                                                 , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                 , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                 , Integer, Integer, Boolean
                                                 , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                 , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                 , Boolean, TVarChar
                                                  );

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_byReport(
    IN inUnitId                Integer  , --
    IN inStartDate             TDateTime,
    IN inEndDate               TDateTime,
    IN inMovementId            Integer,
    IN inMovementItemId        Integer,
    IN inGoodsId               Integer,
    IN inGoodsKindId           Integer,
    IN inPartionGoodsDate      TDateTime, --
 INOUT ioIsChoiceCell_mi       Boolean,
 INOUT ioPartionCellId_1       Integer,
 INOUT ioPartionCellId_2       Integer,
 INOUT ioPartionCellId_3       Integer,
 INOUT ioPartionCellId_4       Integer,
 INOUT ioPartionCellId_5       Integer,
 INOUT ioPartionCellId_6       Integer,
 INOUT ioPartionCellId_7       Integer,
 INOUT ioPartionCellId_8       Integer,
 INOUT ioPartionCellId_9       Integer,
 INOUT ioPartionCellId_10      Integer,
 INOUT ioPartionCellId_11      Integer,
 INOUT ioPartionCellId_12      Integer,
 INOUT ioPartionCellId_13       Integer,
 INOUT ioPartionCellId_14       Integer,
 INOUT ioPartionCellId_15       Integer,
 INOUT ioPartionCellId_16       Integer,
 INOUT ioPartionCellId_17       Integer,
 INOUT ioPartionCellId_18       Integer,
 INOUT ioPartionCellId_19       Integer,
 INOUT ioPartionCellId_20       Integer,
 INOUT ioPartionCellId_21       Integer,
 INOUT ioPartionCellId_22       Integer,

    IN inOrd                   Integer, --є пп
    IN inDescId_milo_num       Integer, --є пп
    IN inIsRePack              Boolean, --є пп
   OUT outPartionCellId_last   Integer,

 INOUT ioPartionCellName_1     TVarChar, --
 INOUT ioPartionCellName_2     TVarChar,
 INOUT ioPartionCellName_3     TVarChar,
 INOUT ioPartionCellName_4     TVarChar,
 INOUT ioPartionCellName_5     TVarChar,
 INOUT ioPartionCellName_6     TVarChar, --
 INOUT ioPartionCellName_7     TVarChar,
 INOUT ioPartionCellName_8     TVarChar,
 INOUT ioPartionCellName_9     TVarChar,
 INOUT ioPartionCellName_10    TVarChar,
 INOUT ioPartionCellName_11    TVarChar,
 INOUT ioPartionCellName_12    TVarChar,
 INOUT ioPartionCellName_13     TVarChar,
 INOUT ioPartionCellName_14     TVarChar,
 INOUT ioPartionCellName_15     TVarChar,
 INOUT ioPartionCellName_16     TVarChar,
 INOUT ioPartionCellName_17     TVarChar,
 INOUT ioPartionCellName_18     TVarChar,
 INOUT ioPartionCellName_19     TVarChar,
 INOUT ioPartionCellName_20     TVarChar,
 INOUT ioPartionCellName_21     TVarChar,
 INOUT ioPartionCellName_22     TVarChar,
    IN inIsLock_record          Boolean,

   OUT outIsPrint              Boolean,
    IN inSession               TVarChar  -- сесси€ пользовател€
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPartionCellId_1 Integer;
   DECLARE vbPartionCellId_2 Integer;
   DECLARE vbPartionCellId_3 Integer;
   DECLARE vbPartionCellId_4 Integer;
   DECLARE vbPartionCellId_5 Integer;
   DECLARE vbPartionCellId_6 Integer;
   DECLARE vbPartionCellId_7 Integer;
   DECLARE vbPartionCellId_8 Integer;
   DECLARE vbPartionCellId_9 Integer;
   DECLARE vbPartionCellId_10 Integer;
   DECLARE vbPartionCellId_11 Integer;
   DECLARE vbPartionCellId_12 Integer;
   DECLARE vbPartionCellId_13 Integer;
   DECLARE vbPartionCellId_14 Integer;
   DECLARE vbPartionCellId_15 Integer;
   DECLARE vbPartionCellId_16 Integer;
   DECLARE vbPartionCellId_17 Integer;
   DECLARE vbPartionCellId_18 Integer;
   DECLARE vbPartionCellId_19 Integer;
   DECLARE vbPartionCellId_20 Integer;
   DECLARE vbPartionCellId_21 Integer;
   DECLARE vbPartionCellId_22 Integer;

   DECLARE vbPartionCellId_old_1 Integer;
   DECLARE vbPartionCellId_old_2 Integer;
   DECLARE vbPartionCellId_old_3 Integer;
   DECLARE vbPartionCellId_old_4 Integer;
   DECLARE vbPartionCellId_old_5 Integer;
   DECLARE vbPartionCellId_old_6 Integer;
   DECLARE vbPartionCellId_old_7 Integer;
   DECLARE vbPartionCellId_old_8 Integer;
   DECLARE vbPartionCellId_old_9 Integer;
   DECLARE vbPartionCellId_old_10 Integer;
   DECLARE vbPartionCellId_old_11 Integer;
   DECLARE vbPartionCellId_old_12 Integer;
   DECLARE vbPartionCellId_old_13 Integer;
   DECLARE vbPartionCellId_old_14 Integer;
   DECLARE vbPartionCellId_old_15 Integer;
   DECLARE vbPartionCellId_old_16 Integer;
   DECLARE vbPartionCellId_old_17 Integer;
   DECLARE vbPartionCellId_old_18 Integer;
   DECLARE vbPartionCellId_old_19 Integer;
   DECLARE vbPartionCellId_old_20 Integer;
   DECLARE vbPartionCellId_old_21 Integer;
   DECLARE vbPartionCellId_old_22 Integer;

   DECLARE vbPartionCellId_old_1_real Integer;
   DECLARE vbPartionCellId_old_2_real Integer;
   DECLARE vbPartionCellId_old_3_real Integer;
   DECLARE vbPartionCellId_old_4_real Integer;
   DECLARE vbPartionCellId_old_5_real Integer;
   DECLARE vbPartionCellId_old_6_real Integer;
   DECLARE vbPartionCellId_old_7_real Integer;
   DECLARE vbPartionCellId_old_8_real Integer;
   DECLARE vbPartionCellId_old_9_real Integer;
   DECLARE vbPartionCellId_old_10_real Integer;
   DECLARE vbPartionCellId_old_11_real Integer;
   DECLARE vbPartionCellId_old_12_real Integer;
   DECLARE vbPartionCellId_old_13_real Integer;
   DECLARE vbPartionCellId_old_14_real Integer;
   DECLARE vbPartionCellId_old_15_real Integer;
   DECLARE vbPartionCellId_old_16_real Integer;
   DECLARE vbPartionCellId_old_17_real Integer;
   DECLARE vbPartionCellId_old_18_real Integer;
   DECLARE vbPartionCellId_old_19_real Integer;
   DECLARE vbPartionCellId_old_20_real Integer;
   DECLARE vbPartionCellId_old_21_real Integer;
   DECLARE vbPartionCellId_old_22_real Integer;

   DECLARE vbIsClose_1  Boolean;
   DECLARE vbIsClose_2  Boolean;
   DECLARE vbIsClose_3  Boolean;
   DECLARE vbIsClose_4  Boolean;
   DECLARE vbIsClose_5  Boolean;
   DECLARE vbIsClose_6  Boolean;
   DECLARE vbIsClose_7  Boolean;
   DECLARE vbIsClose_8  Boolean;
   DECLARE vbIsClose_9  Boolean;
   DECLARE vbIsClose_10 Boolean;
   DECLARE vbIsClose_11 Boolean;
   DECLARE vbIsClose_12 Boolean;
   DECLARE vbIsClose_13  Boolean;
   DECLARE vbIsClose_14  Boolean;
   DECLARE vbIsClose_15  Boolean;
   DECLARE vbIsClose_16  Boolean;
   DECLARE vbIsClose_17  Boolean;
   DECLARE vbIsClose_18  Boolean;
   DECLARE vbIsClose_19  Boolean;
   DECLARE vbIsClose_20 Boolean;
   DECLARE vbIsClose_21 Boolean;
   DECLARE vbIsClose_22 Boolean;
   DECLARE vbMI_Id_check Integer;

   DECLARE vbPartionCellId_tmp  Integer;

BEGIN
     -- проверка прав пользовател€ на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId:= lpGetUserBySession (inSession);


     IF inIsLock_record = TRUE
     THEN
         RAISE EXCEPTION 'ќшибка.%Ќет прав устанавливать €чейку <%>.', CHR (13), lfGet_Object_ValueData_sh(zc_PartionCell_Err());
     END IF;


     IF vbUserId <> 5
        -- –оль - ¬се права дл€ изменений €чейки хранени€
        AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11278315)
        --
        AND vbUserId <> 602817  -- якимчик ј.—.
        AND vbUserId <> 8692657 -- —елезень ≤.™.
        --AND inPartionGoodsDate <> '01.07.2024'
     THEN
         IF TRIM (ioPartionCellName_1) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_1() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_1 > 0
                                                )
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <1>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_2) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_2() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_2 > 0
                                                )
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <2>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_3) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_3() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_3 > 0
                                                )
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <3>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_4) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_4() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_4 > 0
                                                )
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <4>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_5) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_5() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_5 > 0
                                                )
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <5>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_6) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_6() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_6 > 0
                                                )
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <6>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_7) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_7() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_7 > 0
                                                )
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <7>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_8) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_8() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_8 > 0
                                                )
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <8>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_9) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_9() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_9 > 0
                                                )
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <9>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_10) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_10() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_10 > 0
                                                )
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <10>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_11) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_11() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_11 > 0
                                                )
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <11>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_12) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_12() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_12 > 0)
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <12>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_13) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_13() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_13 > 0)
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <13>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_14) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_14() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_14 > 0)
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <14>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_15) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_15() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_15 > 0)
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <15>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_16) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_16() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_16 > 0)
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <16>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_17) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_17() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_17 > 0)
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <17>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_18) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_18() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_18 > 0)
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <18>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_19) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_19() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_19 > 0)
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <19>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_20) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_20() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_20 > 0)
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <20>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_21) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_21() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_21 > 0)
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <21>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
         IF TRIM (ioPartionCellName_22) = '' AND (EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.DescId = zc_MILinkObject_PartionCell_22() AND MILO.MovementItemId = inMovementItemId AND MILO.ObjectId > 0)
                                              OR ioPartionCellId_22 > 0)
         THEN
             RAISE EXCEPTION 'ќшибка.%Ќет прав очищать €чейку <22>.%ћожно выбрать любую €чейку или поставить в отбор.', CHR (13), CHR (13);
         END IF;
     END IF;


     -- обнул€ем последнюю измененную €чейку
     outPartionCellId_last := NULL ::Integer;

/*
if zfConvert_StringToNumber (ioPartionCellName_1) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_1, 1)) > 0   then ioPartionCellName_1     := right (ioPartionCellName_1,  LENGTH(ioPartionCellName_1) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_1, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_1, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_1, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_2) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_2, 1)) > 0   then ioPartionCellName_2     := right (ioPartionCellName_2,  LENGTH(ioPartionCellName_2) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_2, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_2, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_2, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_3) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_3, 1)) > 0   then ioPartionCellName_3     := right (ioPartionCellName_3,  LENGTH(ioPartionCellName_3) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_3, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_3, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_3, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_4) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_4, 1)) > 0   then ioPartionCellName_4     := right (ioPartionCellName_4,  LENGTH(ioPartionCellName_4) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_4, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_4, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_4, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_5) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_5, 1)) > 0   then ioPartionCellName_5     := right (ioPartionCellName_5,  LENGTH(ioPartionCellName_5) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_5, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_5, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_5, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_6) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_6, 1)) > 0   then ioPartionCellName_6     := right (ioPartionCellName_6,  LENGTH(ioPartionCellName_6) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_6, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_6, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_6, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_7) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_7, 1)) > 0   then ioPartionCellName_7     := right (ioPartionCellName_7,  LENGTH(ioPartionCellName_7) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_7, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_7, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_7, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_8) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_8, 1)) > 0   then ioPartionCellName_8     := right (ioPartionCellName_8,  LENGTH(ioPartionCellName_8) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_8, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_8, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_8, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_9) = 0  and zfConvert_StringToNumber (LEFT (ioPartionCellName_9, 1)) > 0   then ioPartionCellName_9     := right (ioPartionCellName_9,  LENGTH(ioPartionCellName_9) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_9, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_9, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_9, 2)) > 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_10) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_10, 1)) > 0  then ioPartionCellName_10    := right (ioPartionCellName_10, LENGTH(ioPartionCellName_10) - CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_10, 4))> 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_10, 3))> 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_10, 2))> 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_11) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_11, 1)) > 0  then ioPartionCellName_11    := right (ioPartionCellName_11, LENGTH(ioPartionCellName_11) - CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_11, 4))> 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_11, 3))> 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_11, 2))> 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_12) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_12, 1)) > 0  then ioPartionCellName_12    := right (ioPartionCellName_12, LENGTH(ioPartionCellName_12) - CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_12, 4))> 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_12, 3))> 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_12, 2))> 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_13) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_13, 1)) > 0  then ioPartionCellName_13    := right (ioPartionCellName_3,  LENGTH(ioPartionCellName_3) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_3, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_3, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_13, 2))> 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_14) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_14, 1)) > 0  then ioPartionCellName_14    := right (ioPartionCellName_4,  LENGTH(ioPartionCellName_4) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_4, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_4, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_14, 2))> 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_15) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_15, 1)) > 0  then ioPartionCellName_15    := right (ioPartionCellName_5,  LENGTH(ioPartionCellName_5) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_5, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_5, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_15, 2))> 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_16) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_16, 1)) > 0  then ioPartionCellName_16    := right (ioPartionCellName_6,  LENGTH(ioPartionCellName_6) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_6, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_6, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_16, 2))> 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_17) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_17, 1)) > 0  then ioPartionCellName_17    := right (ioPartionCellName_7,  LENGTH(ioPartionCellName_7) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_7, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_7, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_17, 2))> 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_18) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_18, 1)) > 0  then ioPartionCellName_18    := right (ioPartionCellName_8,  LENGTH(ioPartionCellName_8) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_8, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_8, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_18, 2))> 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_19) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_19, 1)) > 0  then ioPartionCellName_19    := right (ioPartionCellName_9,  LENGTH(ioPartionCellName_9) -  CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_9, 4)) > 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_9, 3)) > 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_19, 2))> 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_20) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_20, 1)) > 0  then ioPartionCellName_20    := right (ioPartionCellName_10, LENGTH(ioPartionCellName_10) - CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_10, 4))> 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_10, 3))> 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_20, 2))> 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_21) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_21, 1)) > 0  then ioPartionCellName_21    := right (ioPartionCellName_11, LENGTH(ioPartionCellName_11) - CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_11, 4))> 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_11, 3))> 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_21, 2))> 0 THEN 2 ELSE 1 END); end if;
if zfConvert_StringToNumber (ioPartionCellName_22) = 0 and zfConvert_StringToNumber (LEFT (ioPartionCellName_22, 1)) > 0  then ioPartionCellName_22    := right (ioPartionCellName_12, LENGTH(ioPartionCellName_12) - CASE WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_12, 4))> 0 THEN 4 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_12, 3))> 0 THEN 3 WHEN zfConvert_StringToNumber (LEFT (ioPartionCellName_22, 2))> 0 THEN 2 ELSE 1 END); end if;
*/

     -- если не нашли ошибка
     IF COALESCE (inDescId_milo_num, 0) <> 0
     THEN
         RAISE EXCEPTION 'ќшибка.¬ режиме <ѕо €чейкам> нет прав заполн€ть.<%>', inDescId_milo_num;
     END IF;

     -- если не нашли ошибка
     IF COALESCE (inIsRePack, FALSE) = TRUE
     THEN
         RAISE EXCEPTION 'ќшибка.ƒл€ <ѕерепак.> нет прав заполн€ть.';
     END IF;


     --  1
     IF ioPartionCellName_1 ILIKE '%отбор%' OR TRIM (ioPartionCellName_1) = '0'
     THEN
         vbPartionCellId_1:= zc_PartionCell_RK();
     ELSEIF TRIM (ioPartionCellName_1) = '1'
     THEN
         vbPartionCellId_1:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_1, '')) <> ''
         THEN
             -- если ввели код
             IF zfConvert_StringToNumber (ioPartionCellName_1) <> 0
             THEN
                 -- поиск по коду
                 vbPartionCellId_1:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_1)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 -- поиск по названию
                 vbPartionCellId_1:= (SELECT Object.Id
                                      FROM Object
                                      WHERE TRIM (Object.ValueData) ILIKE TRIM (ioPartionCellName_1)
                                        AND Object.DescId           = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_1, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_1:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_1)
                                         );
                 END IF;

             END IF;
             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_1, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_1;
             END IF;

         ELSE
             -- обнулили
             vbPartionCellId_1:= NULL;
         END IF;

     END IF;


     --  2
     IF ioPartionCellName_2 ILIKE '%отбор%' OR TRIM (ioPartionCellName_2) = '0'
     THEN
         vbPartionCellId_2:= zc_PartionCell_RK();
     ELSEIF TRIM (ioPartionCellName_2) = '1'
     THEN
         vbPartionCellId_2:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_2, '')) <> ''
         THEN
             -- если ввели код
             IF zfConvert_StringToNumber (ioPartionCellName_2) <> 0
             THEN
                 -- поиск по коду
                 vbPartionCellId_2:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_2)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 -- поиск по названию
                 vbPartionCellId_2:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_2))
                                        AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_2, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_2:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_2)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_2, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_2;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_2:= NULL;
         END IF;

     END IF;


     --  3
     IF ioPartionCellName_3 ILIKE '%отбор%' OR TRIM (ioPartionCellName_3) = '0'
     THEN
         vbPartionCellId_3:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_3) = '1'
     THEN
         vbPartionCellId_3:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_3, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_3) <> 0
             THEN
                 -- поиск по коду
                 vbPartionCellId_3:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_3)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 -- поиск по названию
                 vbPartionCellId_3:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_3))
                                        AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_3, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_3:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_3)
                                         );
                 END IF;
             END IF;
             --если не нашли ошибка
             IF COALESCE (vbPartionCellId_3, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_3;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_3:= NULL;
         END IF;

     END IF;


     --  4
     IF ioPartionCellName_4 ILIKE '%отбор%' OR TRIM (ioPartionCellName_4) = '0'
     THEN
         vbPartionCellId_4:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_4) = '1'
     THEN
         vbPartionCellId_4:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_4, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_4) <> 0
             THEN
                 -- поиск по коду
                 vbPartionCellId_4:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_4)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 -- поиск по названию
                 vbPartionCellId_4:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_4))
                                        AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_4, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_4:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_4)
                                         );
                 END IF;
             END IF;
             --если не нашли ошибка
             IF COALESCE (vbPartionCellId_4, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_4;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_4:= NULL;
         END IF;

     END IF;


     --  5
     IF ioPartionCellName_5 ILIKE '%отбор%' OR TRIM (ioPartionCellName_5) = '0'
     THEN
         vbPartionCellId_5:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_5) = '1'
     THEN
         vbPartionCellId_5:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_5, '')) <> ''
         THEN
             -- если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_5) <> 0
             THEN
                 vbPartionCellId_5:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_5)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_5:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_5))
                                        AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_5, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_5:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_5)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_5, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_5;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_5:= NULL;
         END IF;

     END IF;


     --  6
     IF ioPartionCellName_6 ILIKE '%отбор%' OR TRIM (ioPartionCellName_6) = '0'
     THEN
         vbPartionCellId_6:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_6) = '1'
     THEN
         vbPartionCellId_6:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_6, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_6) <> 0
             THEN
                 vbPartionCellId_6:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_6)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_6:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_6))
                                        AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_6, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_6:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_6)
                                         );
                 END IF;
             END IF;

             --если не нашли ошибка
             IF COALESCE (vbPartionCellId_6, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_6;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_6:= NULL;
         END IF;

     END IF;


     --  7
     IF ioPartionCellName_7 ILIKE '%отбор%' OR TRIM (ioPartionCellName_7) = '0'
     THEN
         vbPartionCellId_7:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_7) = '1'
     THEN
         vbPartionCellId_7:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_7, '')) <> ''
         THEN
             -- если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_7) <> 0
             THEN
                 vbPartionCellId_7:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_7)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_7:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_7))
                                        AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_7, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_7:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_7)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_7, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_7;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_7:= NULL;
         END IF;

     END IF;


     --  8
     IF ioPartionCellName_8 ILIKE '%отбор%' OR TRIM (ioPartionCellName_8) = '0'
     THEN
         vbPartionCellId_8:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_8) = '1'
     THEN
         vbPartionCellId_8:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_8, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_8) <> 0
             THEN
                 vbPartionCellId_8:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_8)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_8:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_8))
                                        AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_8, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_8:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_8)
                                         );
                 END IF;
             END IF;

             --если не нашли ошибка
             IF COALESCE (vbPartionCellId_8, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_8;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_8:= NULL;
         END IF;

     END IF;


     --  9
     IF ioPartionCellName_9 ILIKE '%отбор%' OR TRIM (ioPartionCellName_9) = '0'
     THEN
         vbPartionCellId_9:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_9) = '1'
     THEN
         vbPartionCellId_9:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_9, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_9) <> 0
             THEN
                 vbPartionCellId_9:= (SELECT Object.Id
                                      FROM Object
                                      WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_9)
                                        AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_9:= (SELECT Object.Id
                                      FROM Object
                                      WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_9))
                                        AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_9, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_9:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_9)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_9, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_9;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_9:= NULL;
         END IF;

     END IF;


     --  10
     IF ioPartionCellName_10 ILIKE '%отбор%' OR TRIM (ioPartionCellName_10) = '0'
     THEN
         vbPartionCellId_10:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_10) = '1'
     THEN
         vbPartionCellId_10:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_10, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_10) <> 0
             THEN
                 vbPartionCellId_10:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_10)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_10:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_10))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_10, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_10:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_10)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_10, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_10;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_10:= NULL;
         END IF;

     END IF;


     --  11
     IF ioPartionCellName_11 ILIKE '%отбор%' OR TRIM (ioPartionCellName_11) = '0'
     THEN
         vbPartionCellId_11:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_11) = '1'
     THEN
         vbPartionCellId_11:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_11, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_11) <> 0
             THEN
                 vbPartionCellId_11:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_11)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_11:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_11))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_11, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_11:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_11)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_11, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_11;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_11:= NULL;
         END IF;

     END IF;


     --  12
     IF ioPartionCellName_12 ILIKE '%отбор%' OR TRIM (ioPartionCellName_12) = '0'
     THEN
         vbPartionCellId_12:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_12) = '1'
     THEN
         vbPartionCellId_12:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_12, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_12) <> 0
             THEN
                 vbPartionCellId_12:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_12)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_12:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_12))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_12, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_12:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_12)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_12, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_12;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_12:= NULL;
         END IF;

     END IF;

     --  13
     IF ioPartionCellName_13 ILIKE '%отбор%' OR TRIM (ioPartionCellName_13) = '0'
     THEN
         vbPartionCellId_13:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_13) = '1'
     THEN
         vbPartionCellId_13:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_13, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_13) <> 0
             THEN
                 vbPartionCellId_13:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_13)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_13:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_13))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_13, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_13:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_13)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_13, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_13;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_13:= NULL;
         END IF;

     END IF;

     --  14
     IF ioPartionCellName_14 ILIKE '%отбор%' OR TRIM (ioPartionCellName_14) = '0'
     THEN
         vbPartionCellId_14:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_14) = '1'
     THEN
         vbPartionCellId_14:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_14, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_14) <> 0
             THEN
                 vbPartionCellId_14:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_14)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_14:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_14))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_14, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_14:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_14)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_14, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_14;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_14:= NULL;
         END IF;

     END IF;

     --  15
     IF ioPartionCellName_15 ILIKE '%отбор%' OR TRIM (ioPartionCellName_15) = '0'
     THEN
         vbPartionCellId_15:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_15) = '1'
     THEN
         vbPartionCellId_15:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_15, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_15) <> 0
             THEN
                 vbPartionCellId_15:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_15)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_15:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_15))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_15, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_15:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_15)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_15, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_15;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_15:= NULL;
         END IF;

     END IF;

     --  16
     IF ioPartionCellName_16 ILIKE '%отбор%' OR TRIM (ioPartionCellName_16) = '0'
     THEN
         vbPartionCellId_16:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_16) = '1'
     THEN
         vbPartionCellId_16:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_16, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_16) <> 0
             THEN
                 vbPartionCellId_16:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_16)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_16:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_16))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_16, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_16:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_16)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_16, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_16;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_16:= NULL;
         END IF;

     END IF;

     --  17
     IF ioPartionCellName_17 ILIKE '%отбор%' OR TRIM (ioPartionCellName_17) = '0'
     THEN
         vbPartionCellId_17:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_17) = '1'
     THEN
         vbPartionCellId_17:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_17, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_17) <> 0
             THEN
                 vbPartionCellId_17:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_17)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_17:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_17))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_17, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_17:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_17)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_17, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_17;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_17:= NULL;
         END IF;

     END IF;


     --  18
     IF ioPartionCellName_18 ILIKE '%отбор%' OR TRIM (ioPartionCellName_18) = '0'
     THEN
         vbPartionCellId_18:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_18) = '1'
     THEN
         vbPartionCellId_18:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_18, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_18) <> 0
             THEN
                 vbPartionCellId_18:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_18)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_18:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_18))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_18, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_18:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_18)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_18, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_18;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_18:= NULL;
         END IF;

     END IF;


     --  19
     IF ioPartionCellName_19 ILIKE '%отбор%' OR TRIM (ioPartionCellName_19) = '0'
     THEN
         vbPartionCellId_19:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_19) = '1'
     THEN
         vbPartionCellId_19:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_19, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_19) <> 0
             THEN
                 vbPartionCellId_19:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_19)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_19:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_19))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_19, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_19:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_19)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_19, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_19;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_19:= NULL;
         END IF;

     END IF;


     --  20
     IF ioPartionCellName_20 ILIKE '%отбор%' OR TRIM (ioPartionCellName_20) = '0'
     THEN
         vbPartionCellId_20:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_20) = '1'
     THEN
         vbPartionCellId_20:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_20, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_20) <> 0
             THEN
                 vbPartionCellId_20:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_20)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_20:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_20))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_20, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_20:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_20)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_20, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_20;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_20:= NULL;
         END IF;

     END IF;

     --  21
     IF ioPartionCellName_21 ILIKE '%отбор%' OR TRIM (ioPartionCellName_21) = '0'
     THEN
         vbPartionCellId_21:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_21) = '1'
     THEN
         vbPartionCellId_21:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_21, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_21) <> 0
             THEN
                 vbPartionCellId_21:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_21)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_21:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_21))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_21, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_21:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_21)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_21, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_21;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_21:= NULL;
         END IF;

     END IF;

     --  22
     IF ioPartionCellName_22 ILIKE '%отбор%' OR TRIM (ioPartionCellName_22) = '0'
     THEN
         vbPartionCellId_22:= zc_PartionCell_RK();

     ELSEIF TRIM (ioPartionCellName_22) = '1'
     THEN
         vbPartionCellId_22:= zc_PartionCell_Err();
     ELSE
         IF TRIM (COALESCE (ioPartionCellName_22, '')) <> ''
         THEN
             --если ввели код ищем по коду, иначе по названию
             IF zfConvert_StringToNumber (ioPartionCellName_22) <> 0
             THEN
                 vbPartionCellId_22:= (SELECT Object.Id
                                       FROM Object
                                       WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_22)
                                         AND Object.DescId     = zc_Object_PartionCell());
             ELSE
                 vbPartionCellId_22:= (SELECT Object.Id
                                       FROM Object
                                       WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName_22))
                                         AND Object.DescId     = zc_Object_PartionCell());
                 -- поиск без разделител€
                 IF COALESCE (vbPartionCellId_22, 0) = 0
                 THEN
                     -- поиск
                     vbPartionCellId_22:= (WITH tmpPartionCell AS (SELECT * FROM Object WHERE Object.DescId = zc_Object_PartionCell() AND Object.isErased = FALSE)
                                          SELECT tmpPartionCell.Id
                                          FROM tmpPartionCell
                                          WHERE REPLACE (TRIM (tmpPartionCell.ValueData), '-', '') ILIKE TRIM (ioPartionCellName_22)
                                         );
                 END IF;
             END IF;

             -- если не нашли ошибка
             IF COALESCE (vbPartionCellId_22, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.Ќе найдена €чейка <%>.', ioPartionCellName_22;
             END IF;
         ELSE
             -- обнулили
             vbPartionCellId_22:= NULL;
         END IF;

     END IF;


     -- –оль - ¬се права дл€ изменений €чейки хранени€
     IF inOrd > 1 AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11278315)
        AND zc_PartionCell_RK() IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5
                                  , vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10
                                  , vbPartionCellId_11, vbPartionCellId_12, vbPartionCellId_13, vbPartionCellId_14, vbPartionCellId_15
                                  , vbPartionCellId_16, vbPartionCellId_17, vbPartionCellId_18, vbPartionCellId_19, vbPartionCellId_20
                                  , vbPartionCellId_21, vbPartionCellId_22
                                   )
        AND vbUserId <> 5
     THEN
         RAISE EXCEPTION 'ќшибка.Ќет прав перемещать в отбор. є п/п должен быть = 1.';
     END IF;


     -- если дублируютс€ €чейки, объедин€ем
     IF vbPartionCellId_2 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_2 IN (vbPartionCellId_1)
     THEN vbPartionCellId_2:= NULL; END IF;

     IF vbPartionCellId_3 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_3 IN (vbPartionCellId_1, vbPartionCellId_2)
     THEN vbPartionCellId_3:= NULL; END IF;

     IF vbPartionCellId_4 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_4 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3)
     THEN vbPartionCellId_4:= NULL; END IF;

     IF vbPartionCellId_5 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_5 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4)
     THEN vbPartionCellId_5:= NULL; END IF;

     IF vbPartionCellId_6 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_6 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5)
     THEN vbPartionCellId_6:= NULL; END IF;

     IF vbPartionCellId_7 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_7 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6)
     THEN vbPartionCellId_7:= NULL; END IF;

     IF vbPartionCellId_8 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_8 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7)
     THEN vbPartionCellId_8:= NULL; END IF;

     IF vbPartionCellId_9 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_9 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8)
     THEN vbPartionCellId_9:= NULL; END IF;

     IF vbPartionCellId_10 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_10 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9)
     THEN vbPartionCellId_10:= NULL; END IF;

     IF vbPartionCellId_11 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_11 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10)
     THEN vbPartionCellId_11:= NULL; END IF;

     IF vbPartionCellId_12 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_12 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, vbPartionCellId_11)
     THEN vbPartionCellId_12:= NULL; END IF;

     IF vbPartionCellId_13 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_13 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, vbPartionCellId_11, vbPartionCellId_12)
     THEN vbPartionCellId_13:= NULL; END IF;

     IF vbPartionCellId_14 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_14 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, vbPartionCellId_11, vbPartionCellId_12, vbPartionCellId_13)
     THEN vbPartionCellId_14:= NULL; END IF;

     IF vbPartionCellId_15 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_15 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, vbPartionCellId_11, vbPartionCellId_12, vbPartionCellId_13, vbPartionCellId_14)
     THEN vbPartionCellId_15:= NULL; END IF;

     IF vbPartionCellId_16 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_16 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, vbPartionCellId_11, vbPartionCellId_12, vbPartionCellId_13, vbPartionCellId_14, vbPartionCellId_15)
     THEN vbPartionCellId_16:= NULL; END IF;

     IF vbPartionCellId_17 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_17 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, vbPartionCellId_11, vbPartionCellId_12, vbPartionCellId_13, vbPartionCellId_14, vbPartionCellId_15, vbPartionCellId_16)
     THEN vbPartionCellId_17:= NULL; END IF;

     IF vbPartionCellId_18 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_18 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, vbPartionCellId_11, vbPartionCellId_12, vbPartionCellId_13, vbPartionCellId_14, vbPartionCellId_15, vbPartionCellId_16, vbPartionCellId_17)
     THEN vbPartionCellId_18:= NULL; END IF;

     IF vbPartionCellId_19 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_19 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, vbPartionCellId_11, vbPartionCellId_12, vbPartionCellId_13, vbPartionCellId_14, vbPartionCellId_15, vbPartionCellId_16, vbPartionCellId_17, vbPartionCellId_18)
     THEN vbPartionCellId_19:= NULL; END IF;

     IF vbPartionCellId_20 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_20 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, vbPartionCellId_11, vbPartionCellId_12, vbPartionCellId_13, vbPartionCellId_14, vbPartionCellId_15, vbPartionCellId_16, vbPartionCellId_17, vbPartionCellId_18, vbPartionCellId_19)
     THEN vbPartionCellId_20:= NULL; END IF;

     IF vbPartionCellId_21 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_21 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, vbPartionCellId_11, vbPartionCellId_12, vbPartionCellId_13, vbPartionCellId_14, vbPartionCellId_15, vbPartionCellId_16, vbPartionCellId_17, vbPartionCellId_18, vbPartionCellId_19, vbPartionCellId_20)
     THEN vbPartionCellId_21:= NULL; END IF;

     IF vbPartionCellId_22 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err()) AND vbPartionCellId_22 IN (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, vbPartionCellId_11, vbPartionCellId_12, vbPartionCellId_13, vbPartionCellId_14, vbPartionCellId_15, vbPartionCellId_16, vbPartionCellId_17, vbPartionCellId_18, vbPartionCellId_19, vbPartionCellId_20, vbPartionCellId_21)
     THEN vbPartionCellId_22:= NULL; END IF;


     -- ѕроверка - €чейку-–еал на €чейку-–еал мен€ть нельз€
     IF ((ioPartionCellId_1  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_1,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_1  <> vbPartionCellId_1)
      OR (ioPartionCellId_2  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_2,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_2  <> vbPartionCellId_2)
      OR (ioPartionCellId_3  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_3,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_3  <> vbPartionCellId_3)
      OR (ioPartionCellId_4  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_4,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_4  <> vbPartionCellId_4)
      OR (ioPartionCellId_5  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_5,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_5  <> vbPartionCellId_5)
      OR (ioPartionCellId_6  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_6,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_6  <> vbPartionCellId_6)
      OR (ioPartionCellId_7  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_7,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_7  <> vbPartionCellId_7)
      OR (ioPartionCellId_8  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_8,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_8  <> vbPartionCellId_8)
      OR (ioPartionCellId_9  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_9,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_9  <> vbPartionCellId_9)
      OR (ioPartionCellId_10 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_10, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_10 <> vbPartionCellId_10)
      OR (ioPartionCellId_11 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_11, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_11 <> vbPartionCellId_11)
      OR (ioPartionCellId_12 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_12, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_12 <> vbPartionCellId_12)
      OR (ioPartionCellId_13 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_13, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_13 <> vbPartionCellId_13)
      OR (ioPartionCellId_14 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_14, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_14 <> vbPartionCellId_14)
      OR (ioPartionCellId_15 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_15, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_15 <> vbPartionCellId_15)
      OR (ioPartionCellId_16 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_16, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_16 <> vbPartionCellId_16)
      OR (ioPartionCellId_17 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_17, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_17 <> vbPartionCellId_17)
      OR (ioPartionCellId_18 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_18, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_18 <> vbPartionCellId_18)
      OR (ioPartionCellId_19 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_19, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_19 <> vbPartionCellId_19)
      OR (ioPartionCellId_20 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_20, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_20 <> vbPartionCellId_20)
      OR (ioPartionCellId_21 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_21, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_21 <> vbPartionCellId_21)
      OR (ioPartionCellId_22 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_22, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_22 <> vbPartionCellId_22)
       )
     -- –оль - ¬се права дл€ изменений €чейки хранени€
     AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11278315)
     --AND vbUserId <> 5
     THEN
         -- замена €чейки с ќшибки
         RAISE EXCEPTION 'ќшибка.Ќет прав замен€ть €чейку <%> на €чейку <%>.'
                       , lfGet_Object_ValueData_sh ((SELECT CASE WHEN ioPartionCellId_1  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_1,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_1  <> vbPartionCellId_1  THEN ioPartionCellId_1
                                                                 WHEN ioPartionCellId_2  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_2,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_2  <> vbPartionCellId_2  THEN ioPartionCellId_2
                                                                 WHEN ioPartionCellId_3  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_3,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_3  <> vbPartionCellId_3  THEN ioPartionCellId_3
                                                                 WHEN ioPartionCellId_4  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_4,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_4  <> vbPartionCellId_4  THEN ioPartionCellId_4
                                                                 WHEN ioPartionCellId_5  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_5,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_5  <> vbPartionCellId_5  THEN ioPartionCellId_5
                                                                 WHEN ioPartionCellId_6  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_6,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_6  <> vbPartionCellId_6  THEN ioPartionCellId_6
                                                                 WHEN ioPartionCellId_7  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_7,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_7  <> vbPartionCellId_7  THEN ioPartionCellId_7
                                                                 WHEN ioPartionCellId_8  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_8,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_8  <> vbPartionCellId_8  THEN ioPartionCellId_8
                                                                 WHEN ioPartionCellId_9  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_9,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_9  <> vbPartionCellId_9  THEN ioPartionCellId_9
                                                                 WHEN ioPartionCellId_10 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_10, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_10 <> vbPartionCellId_10 THEN ioPartionCellId_10
                                                                 WHEN ioPartionCellId_11 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_11, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_11 <> vbPartionCellId_11 THEN ioPartionCellId_11
                                                                 WHEN ioPartionCellId_12 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_12, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_12 <> vbPartionCellId_12 THEN ioPartionCellId_12
                                                                 WHEN ioPartionCellId_13 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_13, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_13 <> vbPartionCellId_13 THEN ioPartionCellId_13
                                                                 WHEN ioPartionCellId_14 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_14, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_14 <> vbPartionCellId_14 THEN ioPartionCellId_14
                                                                 WHEN ioPartionCellId_15 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_15, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_15 <> vbPartionCellId_15 THEN ioPartionCellId_15
                                                                 WHEN ioPartionCellId_16 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_16, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_16 <> vbPartionCellId_16 THEN ioPartionCellId_16
                                                                 WHEN ioPartionCellId_17 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_17, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_17 <> vbPartionCellId_17 THEN ioPartionCellId_17
                                                                 WHEN ioPartionCellId_18 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_18, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_18 <> vbPartionCellId_18 THEN ioPartionCellId_18
                                                                 WHEN ioPartionCellId_19 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_19, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_19 <> vbPartionCellId_19 THEN ioPartionCellId_19
                                                                 WHEN ioPartionCellId_20 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_20, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_20 <> vbPartionCellId_20 THEN ioPartionCellId_20
                                                                 WHEN ioPartionCellId_21 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_21, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_21 <> vbPartionCellId_21 THEN ioPartionCellId_21
                                                                 WHEN ioPartionCellId_22 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_22, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_22 <> vbPartionCellId_22 THEN ioPartionCellId_22
                                                            END))
                       , lfGet_Object_ValueData_sh ((SELECT CASE WHEN ioPartionCellId_1  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_1,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_1  <> vbPartionCellId_1  THEN vbPartionCellId_1
                                                                 WHEN ioPartionCellId_2  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_2,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_2  <> vbPartionCellId_2  THEN vbPartionCellId_2
                                                                 WHEN ioPartionCellId_3  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_3,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_3  <> vbPartionCellId_3  THEN vbPartionCellId_3
                                                                 WHEN ioPartionCellId_4  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_4,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_4  <> vbPartionCellId_4  THEN vbPartionCellId_4
                                                                 WHEN ioPartionCellId_5  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_5,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_5  <> vbPartionCellId_5  THEN vbPartionCellId_5
                                                                 WHEN ioPartionCellId_6  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_6,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_6  <> vbPartionCellId_6  THEN vbPartionCellId_6
                                                                 WHEN ioPartionCellId_7  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_7,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_7  <> vbPartionCellId_7  THEN vbPartionCellId_7
                                                                 WHEN ioPartionCellId_8  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_8,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_8  <> vbPartionCellId_8  THEN vbPartionCellId_8
                                                                 WHEN ioPartionCellId_9  NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_9,  0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_9  <> vbPartionCellId_9  THEN vbPartionCellId_9
                                                                 WHEN ioPartionCellId_10 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_10, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_10 <> vbPartionCellId_10 THEN vbPartionCellId_10
                                                                 WHEN ioPartionCellId_11 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_11, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_11 <> vbPartionCellId_11 THEN vbPartionCellId_11
                                                                 WHEN ioPartionCellId_12 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_12, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_12 <> vbPartionCellId_12 THEN vbPartionCellId_12
                                                                 WHEN ioPartionCellId_13 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_13, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_13 <> vbPartionCellId_13 THEN vbPartionCellId_13
                                                                 WHEN ioPartionCellId_14 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_14, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_14 <> vbPartionCellId_14 THEN vbPartionCellId_14
                                                                 WHEN ioPartionCellId_15 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_15, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_15 <> vbPartionCellId_15 THEN vbPartionCellId_15
                                                                 WHEN ioPartionCellId_16 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_16, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_16 <> vbPartionCellId_16 THEN vbPartionCellId_16
                                                                 WHEN ioPartionCellId_17 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_17, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_17 <> vbPartionCellId_17 THEN vbPartionCellId_17
                                                                 WHEN ioPartionCellId_18 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_18, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_18 <> vbPartionCellId_18 THEN vbPartionCellId_18
                                                                 WHEN ioPartionCellId_19 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_19, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_19 <> vbPartionCellId_19 THEN vbPartionCellId_19
                                                                 WHEN ioPartionCellId_20 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_20, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_20 <> vbPartionCellId_20 THEN vbPartionCellId_20
                                                                 WHEN ioPartionCellId_21 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_21, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_21 <> vbPartionCellId_21 THEN vbPartionCellId_21
                                                                 WHEN ioPartionCellId_22 NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND COALESCE (vbPartionCellId_22, 0) NOT IN (0, zc_PartionCell_Err(), zc_PartionCell_RK()) AND ioPartionCellId_22 <> vbPartionCellId_22 THEN vbPartionCellId_22
                                                            END))
                        ;
     END IF;

     -- ѕроверка - €чейку с ќшибки нельз€ мен€ть
     IF ((ioPartionCellId_1  = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_1,  0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_2  = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_2,  0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_3  = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_3,  0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_4  = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_4,  0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_5  = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_5,  0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_6  = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_6,  0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_7  = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_7,  0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_8  = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_8,  0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_9  = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_9,  0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_10 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_10, 0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_11 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_11, 0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_12 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_12, 0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_13 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_13, 0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_14 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_14, 0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_15 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_15, 0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_16 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_16, 0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_17 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_17, 0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_18 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_18, 0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_19 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_19, 0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_20 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_20, 0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_21 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_21, 0) <> zc_PartionCell_Err())
      OR (ioPartionCellId_22 = zc_PartionCell_Err() AND COALESCE (vbPartionCellId_22, 0) <> zc_PartionCell_Err())
       )
     -- –оль - ¬се права дл€ изменений €чейки хранени€
     AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11278315)
     AND vbUserId <> 5
     THEN
         -- замена €чейки с ќшибки
         RAISE EXCEPTION 'ќшибка.Ќет прав замен€ть €чейку <%>.', lfGet_Object_ValueData_sh (zc_PartionCell_Err());
     END IF;


     -- ѕроверка - €чейку на ќшибку нельз€ мен€ть
     IF ((ioPartionCellId_1  <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_1,  0) = zc_PartionCell_Err())
      OR (ioPartionCellId_2  <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_2,  0) = zc_PartionCell_Err())
      OR (ioPartionCellId_3  <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_3,  0) = zc_PartionCell_Err())
      OR (ioPartionCellId_4  <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_4,  0) = zc_PartionCell_Err())
      OR (ioPartionCellId_5  <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_5,  0) = zc_PartionCell_Err())
      OR (ioPartionCellId_6  <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_6,  0) = zc_PartionCell_Err())
      OR (ioPartionCellId_7  <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_7,  0) = zc_PartionCell_Err())
      OR (ioPartionCellId_8  <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_8,  0) = zc_PartionCell_Err())
      OR (ioPartionCellId_9  <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_9,  0) = zc_PartionCell_Err())
      OR (ioPartionCellId_10 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_10, 0) = zc_PartionCell_Err())
      OR (ioPartionCellId_11 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_11, 0) = zc_PartionCell_Err())
      OR (ioPartionCellId_12 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_12, 0) = zc_PartionCell_Err())
      OR (ioPartionCellId_13 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_13, 0) = zc_PartionCell_Err())
      OR (ioPartionCellId_14 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_14, 0) = zc_PartionCell_Err())
      OR (ioPartionCellId_15 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_15, 0) = zc_PartionCell_Err())
      OR (ioPartionCellId_16 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_16, 0) = zc_PartionCell_Err())
      OR (ioPartionCellId_17 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_17, 0) = zc_PartionCell_Err())
      OR (ioPartionCellId_18 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_18, 0) = zc_PartionCell_Err())
      OR (ioPartionCellId_19 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_19, 0) = zc_PartionCell_Err())
      OR (ioPartionCellId_20 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_20, 0) = zc_PartionCell_Err())
      OR (ioPartionCellId_21 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_21, 0) = zc_PartionCell_Err())
      OR (ioPartionCellId_22 <> zc_PartionCell_Err() AND COALESCE (vbPartionCellId_22, 0) = zc_PartionCell_Err())
       )
     -- –оль - ¬се права дл€ изменений €чейки хранени€
     AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11278315)
     -- –оль - –азрешено замена €чейки Ќј ќшибку
     AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11539212)
     --
     AND vbUserId <> 5
     AND 1=1
     THEN
         -- замена €чейки на ќшибку
         RAISE EXCEPTION 'ќшибка.Ќет прав замен€ть на €чейку <%>.', lfGet_Object_ValueData_sh (zc_PartionCell_Err());
     END IF;

     -- 1. ѕроверка - дл€ €чейки может быть только одна парти€
     IF vbPartionCellId_1 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_1
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%> <%>% <%> <%>.%(%)'
                           , lfGet_Object_ValueData (vbPartionCellId_1)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT  Movement.InvNumber FROM MovementItem AS MI JOIN Movement ON Movement.Id = MI.MovementId WHERE MI.Id = vbMI_Id_check)
                           , (SELECT  zfConvert_DateToString (Movement.OperDate) FROM MovementItem AS MI JOIN Movement ON Movement.Id = MI.MovementId WHERE MI.Id = vbMI_Id_check)
                           , (SELECT  MovementDesc.ItemName FROM MovementItem AS MI JOIN Movement ON Movement.Id = MI.MovementId JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE MI.Id = vbMI_Id_check)
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                           , CHR (13)
                           , vbMI_Id_check
                            ;
         END IF;

     END IF;

     -- 2. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_2 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_2
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_2)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 3. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_3 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_3
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_3)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 4. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_4 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_4
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_4)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 5. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_5 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_5
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_5)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 6. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_6 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_6
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_6)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 7. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_7 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_7
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_7)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 8. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_8 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_8
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_8)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 9. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_9 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_9
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_9)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 10. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_10 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_10
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_10)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 11. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_11 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_11
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_11)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- 12. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_12 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_12
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_12)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 13. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_13 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_13
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_13)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 14. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_14 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_14
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_14)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 15. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_15 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_15
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_15)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 16. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_16 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_16
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_16)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 17. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_17 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_17
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_17)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 18. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_18 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_18
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_18)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 19. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_19 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_19
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_19)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 20. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_20 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_20
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_20)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 21. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_21 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_21
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_21)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;

     -- 22. ѕроверка - в €чейке только одна парти€
     IF vbPartionCellId_22 > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell (inPartionCellId   := vbPartionCellId_22
                                                    , inGoodsId         := inGoodsId
                                                    , inGoodsKindId     := inGoodsKindId
                                                    , inPartionGoodsDate:= inPartionGoodsDate
                                                    , inUserId          := vbUserId
                                                     );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'ќшибка.ƒл€ €чейки <%> %уже установлена парти€ <%> % <%> <%>.'
                           , lfGet_Object_ValueData (vbPartionCellId_22)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                            ;
         END IF;

     END IF;


     -- сохранить
     IF inMovementItemId <> 0
     THEN
         --
         /*IF vbPartionCellId_6  <> 0 THEN RAISE EXCEPTION 'ќшибка.ячейка є 6 только дл€ просмотра.'; END IF;
         IF vbPartionCellId_7  <> 0 THEN RAISE EXCEPTION 'ќшибка.ячейка є 7 только дл€ просмотра.'; END IF;
         IF vbPartionCellId_8  <> 0 THEN RAISE EXCEPTION 'ќшибка.ячейка є 8 только дл€ просмотра.'; END IF;
         IF vbPartionCellId_9  <> 0 THEN RAISE EXCEPTION 'ќшибка.ячейка є 9 только дл€ просмотра.'; END IF;
         IF vbPartionCellId_10 <> 0 THEN RAISE EXCEPTION 'ќшибка.ячейка є 10 только дл€ просмотра.'; END IF;*/


         IF EXISTS (SELECT 1
                    FROM MovementItem
                    WHERE MovementItem.Id       = inMovementItemId
                      AND MovementItem.DescId   = zc_MI_Master()
                      AND MovementItem.isErased = TRUE
                   )
         THEN
             RAISE EXCEPTION 'ќшибка.Ќельз€ заполнить место хранени€.%Ёлемент взвешивани€ удален.%ќбновите информацию в отчете.'
                           , CHR (13), CHR (13)
                            ;
         END IF;

         IF EXISTS (SELECT 1
                    FROM MovementItem
                         INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                            AND Movement.DescId   = zc_Movement_WeighingProduction()
                                            AND Movement.StatusId <> zc_Enum_Status_UnComplete()
                    WHERE MovementItem.Id       = inMovementItemId
                      AND MovementItem.DescId   = zc_MI_Master()
                      AND MovementItem.isErased = FALSE
                   )
         THEN
             RAISE EXCEPTION 'ќшибка.Ќельз€ заполнить место хранени€.%ƒокумент взвешивани€ уже закрыт.%ќбновите информацию в отчете.'
                           , CHR (13), CHR (13)
                            ;
         END IF;


         -- 1. обнулили
         IF COALESCE (vbPartionCellId_1, 0) = 0
         THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inMovementItemId, FALSE);

             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inMovementItemId, NULL);
             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_1 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_1()
                                             ), 0);

             -- реальна€ €чейка
             vbPartionCellId_old_1:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- если была реальна€ €чейка
             IF vbPartionCellId_old_1 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), inMovementItemId, vbPartionCellId_old_1 :: TFloat);
             ELSE
                 -- попробуем найти, если сохран€ли оригинал
                 vbPartionCellId_old_1:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_1() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- прив€зали €чейку - ячейка ќтбор
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inMovementItemId, vbPartionCellId_1);
             -- закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inMovementItemId, TRUE);
             -- вернули
             vbIsClose_1:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_1, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_1 ::Integer;

         ELSE
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inMovementItemId, vbPartionCellId_1);
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), inMovementItemId, 0 :: TFloat);
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_1 ::Integer;
             vbIsClose_1:= FALSE;

         END IF;


         -- 2. обнулили
         IF COALESCE (vbPartionCellId_2, 0) = 0
         THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), inMovementItemId, FALSE);

             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inMovementItemId, NULL);
             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_2(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_2 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_2()
                                             ), 0);
             -- реальна€ €чейка
             vbPartionCellId_old_2:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- если была реальна€ €чейка
             IF vbPartionCellId_old_2 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_2(), inMovementItemId, vbPartionCellId_old_2 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_2:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_2() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inMovementItemId, vbPartionCellId_2);
             -- закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), inMovementItemId, TRUE);
             --
             vbIsClose_2:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_2, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_2 ::Integer;

         ELSE
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), inMovementItemId, vbPartionCellId_2);
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_2(), inMovementItemId, 0 :: TFloat);
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_2 ::Integer;
             vbIsClose_2:= FALSE;

         END IF;


         -- 3. обнулили
         IF COALESCE (vbPartionCellId_3, 0) = 0
         THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), inMovementItemId, FALSE);

             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inMovementItemId, NULL);
             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_3(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_3 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_3()
                                             ), 0);
             -- реальна€ €чейка
             vbPartionCellId_old_3:=  (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- если была реальна€ €чейка
             IF vbPartionCellId_old_3 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_3(), inMovementItemId, vbPartionCellId_old_3 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_3:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_3() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inMovementItemId, vbPartionCellId_3);
             -- закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), inMovementItemId, TRUE);
             --
             vbIsClose_3:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_3, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_3 ::Integer;

         ELSE
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), inMovementItemId, vbPartionCellId_3);
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_3(), inMovementItemId, 0 :: TFloat);
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_3 ::Integer;
             vbIsClose_3:= FALSE;

         END IF;


         -- 4. обнулили
         IF COALESCE (vbPartionCellId_4, 0) = 0
         THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), inMovementItemId, FALSE);

             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inMovementItemId, NULL);
             -- обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_4(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_4 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_4()
                                             ), 0);
             -- реальна€ €чейка
             vbPartionCellId_old_4:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- если была реальна€ €чейка
             IF vbPartionCellId_old_4 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_4(), inMovementItemId, vbPartionCellId_old_4 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_4:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_4() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inMovementItemId, vbPartionCellId_4);
             -- закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), inMovementItemId, TRUE);
             --
             vbIsClose_4:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_4, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_4 ::Integer;

         ELSE
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), inMovementItemId, vbPartionCellId_4);
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_4(), inMovementItemId, 0 :: TFloat);
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_4 ::Integer;
             vbIsClose_4:= FALSE;

         END IF;


         -- 5. обнулили
         IF COALESCE (vbPartionCellId_5, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_5(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_5 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_5()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_5:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_5 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_5(), inMovementItemId, vbPartionCellId_old_5 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_5:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_5() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inMovementItemId, vbPartionCellId_5);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), inMovementItemId, TRUE);
             --
             vbIsClose_5:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_5, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_5 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), inMovementItemId, vbPartionCellId_5);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_5(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_5 ::Integer;
             vbIsClose_5:= FALSE;

         END IF;


         -- 6. обнулили
         IF COALESCE (vbPartionCellId_6, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_6(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_6(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_6(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_6 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_6()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_6:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_6 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_6(), inMovementItemId, vbPartionCellId_old_6 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_6:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_6() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_6(), inMovementItemId, vbPartionCellId_6);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_6(), inMovementItemId, TRUE);
             --
             vbIsClose_6:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_6, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_6 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_6(), inMovementItemId, vbPartionCellId_6);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_6(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_6(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_6 ::Integer;
             vbIsClose_6:= FALSE;

         END IF;


         -- 7. обнулили
         IF COALESCE (vbPartionCellId_7, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_7(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_7(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_7(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_7 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_7()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_7:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_7 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_7(), inMovementItemId, vbPartionCellId_old_7 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_7:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_7() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_7(), inMovementItemId, vbPartionCellId_7);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_7(), inMovementItemId, TRUE);
             --
             vbIsClose_7:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_7, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_7 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_7(), inMovementItemId, vbPartionCellId_7);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_7(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_7(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_7 ::Integer;
             vbIsClose_7:= FALSE;

         END IF;


         -- 8. обнулили
         IF COALESCE (vbPartionCellId_8, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_8(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_8(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_8(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_8 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_8()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_8:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_8 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_8(), inMovementItemId, vbPartionCellId_old_8 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_8:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_8() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_8(), inMovementItemId, vbPartionCellId_8);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_8(), inMovementItemId, TRUE);
             --
             vbIsClose_8:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_8, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_8 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_8(), inMovementItemId, vbPartionCellId_8);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_8(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_8(), inMovementItemId, FALSE);

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_8 ::Integer;
             vbIsClose_8:= FALSE;

         END IF;


         -- 9. обнулили
         IF COALESCE (vbPartionCellId_9, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_9(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_9(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_9(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_9 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_9()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_9:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_9 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_9(), inMovementItemId, vbPartionCellId_old_9 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_9:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_9() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_9(), inMovementItemId, vbPartionCellId_9);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_9(), inMovementItemId, TRUE);
             --
             vbIsClose_9:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_9, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_9 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_9(), inMovementItemId, vbPartionCellId_9);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_9(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_9(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_9 ::Integer;
             vbIsClose_9:= FALSE;

         END IF;


         -- 10. обнулили
         IF COALESCE (vbPartionCellId_10, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_10(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_10(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_10(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_10 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_10()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_10:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_10 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_10(), inMovementItemId, vbPartionCellId_old_10 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_10:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_10() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_10(), inMovementItemId, vbPartionCellId_10);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_10(), inMovementItemId, TRUE);
             --
             vbIsClose_10:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_10, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_10 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_10(), inMovementItemId, vbPartionCellId_10);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_10(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_10(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_10 ::Integer;
             vbIsClose_10:= FALSE;

         END IF;


         -- 11. обнулили
         IF COALESCE (vbPartionCellId_11, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_11(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_11(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_11(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_11 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_11()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_11:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_11 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_11(), inMovementItemId, vbPartionCellId_old_11 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_11:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_11() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_11(), inMovementItemId, vbPartionCellId_11);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_11(), inMovementItemId, TRUE);
             --
             vbIsClose_11:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_11, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_11 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_11(), inMovementItemId, vbPartionCellId_11);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_11(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_11(), inMovementItemId, FALSE);

             --записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_11 ::Integer;
             vbIsClose_11:= FALSE;

         END IF;


         -- 12. обнулили
         IF COALESCE (vbPartionCellId_12, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_12(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_12(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_12(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_12 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_12()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_12:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_12 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_12(), inMovementItemId, vbPartionCellId_old_12 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_12:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_12() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_12(), inMovementItemId, vbPartionCellId_12);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_12(), inMovementItemId, TRUE);
             --
             vbIsClose_12:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_12, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_12 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_12(), inMovementItemId, vbPartionCellId_12);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_12(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_12(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_12 ::Integer;
             vbIsClose_12:= FALSE;

         END IF;


         -- 13. обнулили
         IF COALESCE (vbPartionCellId_13, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_13(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_13(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_13(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_13 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_13()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_13:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_13 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_13(), inMovementItemId, vbPartionCellId_old_13 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_13:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_13() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_13(), inMovementItemId, vbPartionCellId_13);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_13(), inMovementItemId, TRUE);
             --
             vbIsClose_13:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_13, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_13 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_13(), inMovementItemId, vbPartionCellId_13);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_13(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_13(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_13 ::Integer;
             vbIsClose_13:= FALSE;

         END IF;


         -- 14. обнулили
         IF COALESCE (vbPartionCellId_14, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_14(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_14(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_14(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_14 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_14()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_14:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_14 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_14(), inMovementItemId, vbPartionCellId_old_14 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_14:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_14() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_14(), inMovementItemId, vbPartionCellId_14);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_14(), inMovementItemId, TRUE);
             --
             vbIsClose_14:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_14, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_14 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_14(), inMovementItemId, vbPartionCellId_14);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_14(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_14(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_14 ::Integer;
             vbIsClose_14:= FALSE;

         END IF;


         -- 15. обнулили
         IF COALESCE (vbPartionCellId_15, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_15(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_15(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_15(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_15 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_15()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_15:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_15 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_15(), inMovementItemId, vbPartionCellId_old_15 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_15:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_15() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_15(), inMovementItemId, vbPartionCellId_15);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_15(), inMovementItemId, TRUE);
             --
             vbIsClose_15:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_15, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_15 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_15(), inMovementItemId, vbPartionCellId_15);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_15(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_15(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_15 ::Integer;
             vbIsClose_15:= FALSE;

         END IF;


         -- 16. обнулили
         IF COALESCE (vbPartionCellId_16, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_16(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_16(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_16(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_16 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_16()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_16:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_16 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_16(), inMovementItemId, vbPartionCellId_old_16 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_16:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_16() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_16(), inMovementItemId, vbPartionCellId_16);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_16(), inMovementItemId, TRUE);
             --
             vbIsClose_16:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_16, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_16 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_16(), inMovementItemId, vbPartionCellId_16);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_16(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_16(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_16 ::Integer;
             vbIsClose_16:= FALSE;

         END IF;


         -- 17. обнулили
         IF COALESCE (vbPartionCellId_17, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_17(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_17(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_17(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_17 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_17()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_17:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_17 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_17(), inMovementItemId, vbPartionCellId_old_17 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_17:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_17() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_17(), inMovementItemId, vbPartionCellId_17);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_17(), inMovementItemId, TRUE);
             --
             vbIsClose_17:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_17, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_17 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_17(), inMovementItemId, vbPartionCellId_17);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_17(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_17(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_17 ::Integer;
             vbIsClose_17:= FALSE;

         END IF;


         -- 18. обнулили
         IF COALESCE (vbPartionCellId_18, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_18(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_18(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_18(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_18 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_18()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_18:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_18 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_18(), inMovementItemId, vbPartionCellId_old_18 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_18:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_18() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_18(), inMovementItemId, vbPartionCellId_18);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_18(), inMovementItemId, TRUE);
             --
             vbIsClose_18:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_18, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_18 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_18(), inMovementItemId, vbPartionCellId_18);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_18(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_18(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_18 ::Integer;
             vbIsClose_18:= FALSE;

         END IF;


         -- 19. обнулили
         IF COALESCE (vbPartionCellId_19, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_19(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_19(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_19(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_19 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_19()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_19:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_19 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_19(), inMovementItemId, vbPartionCellId_old_19 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_19:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_19() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_19(), inMovementItemId, vbPartionCellId_19);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_19(), inMovementItemId, TRUE);
             --
             vbIsClose_19:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_19, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_19 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_19(), inMovementItemId, vbPartionCellId_19);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_19(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_19(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_19 ::Integer;
             vbIsClose_19:= FALSE;

         END IF;


         -- 20. обнулили
         IF COALESCE (vbPartionCellId_20, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_20(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_20(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_20(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_20 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_20()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_20:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_20 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_20(), inMovementItemId, vbPartionCellId_old_20 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_20:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_20() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_20(), inMovementItemId, vbPartionCellId_20);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_20(), inMovementItemId, TRUE);
             --
             vbIsClose_20:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_20, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_20 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_20(), inMovementItemId, vbPartionCellId_20);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_20(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_20(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_20 ::Integer;
             vbIsClose_20:= FALSE;

         END IF;


         -- 21. обнулили
         IF COALESCE (vbPartionCellId_21, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_21(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_21(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_21(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_21 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_21()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_21:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_21 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_21(), inMovementItemId, vbPartionCellId_old_21 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_21:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_21() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_21(), inMovementItemId, vbPartionCellId_21);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_21(), inMovementItemId, TRUE);
             --
             vbIsClose_21:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_21, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_21 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_21(), inMovementItemId, vbPartionCellId_21);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_21(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_21(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_21 ::Integer;
             vbIsClose_21:= FALSE;

         END IF;


         -- 22. обнулили
         IF COALESCE (vbPartionCellId_22, 0) = 0
         THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_22(), inMovementItemId, FALSE);

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_22(), inMovementItemId, NULL);
             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_22(), inMovementItemId, 0 :: TFloat);

         ELSEIF vbPartionCellId_22 = zc_PartionCell_RK()
         THEN
             -- реальна€ €чейка
             vbPartionCellId_tmp:= COALESCE ((SELECT MILO.ObjectId
                                              FROM MovementItemLinkObject AS MILO
                                              WHERE MILO.MovementItemId = inMovementItemId AND MILO.DescId = zc_MILinkObject_PartionCell_22()
                                             ), 0);
             -- 2.1.реальна€ €чейка - потом сохранить
             vbPartionCellId_old_22:= (SELECT vbPartionCellId_tmp WHERE vbPartionCellId_tmp <> zc_PartionCell_RK());

             -- 2.2.если была реальна€ €чейка
             IF vbPartionCellId_old_22 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_22(), inMovementItemId, vbPartionCellId_old_22 :: TFloat);
             ELSE
                 -- попробуем найти
                 vbPartionCellId_old_22:= (SELECT MIF.ValueData :: Integer
                                          FROM MovementItemFloat AS MIF
                                          WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_PartionCell_real_22() AND MIF.ValueData NOT IN (zc_PartionCell_RK(), 0)
                                         );
             END IF;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_22(), inMovementItemId, vbPartionCellId_22);
             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_22(), inMovementItemId, TRUE);
             --
             vbIsClose_22:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (vbPartionCellId_old_22, 0) = 0 AND vbPartionCellId_tmp = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_22 ::Integer;

         ELSE
             -- 3.1.прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_22(), inMovementItemId, vbPartionCellId_22);
             -- 3.2.обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_22(), inMovementItemId, 0 :: TFloat);
             -- 3.3.открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_22(), inMovementItemId, FALSE);

             -- записываем последнюю измененную €чейку
             outPartionCellId_last := vbPartionCellId_22 ::Integer;
             vbIsClose_22:= FALSE;

         END IF;


         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);


     ELSE

         SELECT outPartionCellId_1, outPartionCellId_2, outPartionCellId_3, outPartionCellId_4, outPartionCellId_5
              , outPartionCellId_6, outPartionCellId_7, outPartionCellId_8, outPartionCellId_9, outPartionCellId_10
              , outPartionCellId_11, outPartionCellId_12, outPartionCellId_13, outPartionCellId_14, outPartionCellId_15
              , outPartionCellId_16, outPartionCellId_17, outPartionCellId_18, outPartionCellId_19, outPartionCellId_20
              , outPartionCellId_21, outPartionCellId_22
              , outIsClose_1, outIsClose_2, outIsClose_3, outIsClose_4, outIsClose_5, outIsClose_6, outIsClose_7, outIsClose_8, outIsClose_9, outIsClose_10
              , outIsClose_11, outIsClose_12, outIsClose_13, outIsClose_14, outIsClose_15, outIsClose_16, outIsClose_17, outIsClose_18, outIsClose_19, outIsClose_20
              , outIsClose_21, outIsClose_22
         INTO vbPartionCellId_old_1, vbPartionCellId_old_2, vbPartionCellId_old_3, vbPartionCellId_old_4, vbPartionCellId_old_5
            , vbPartionCellId_old_6, vbPartionCellId_old_7, vbPartionCellId_old_8, vbPartionCellId_old_9, vbPartionCellId_old_10
            , vbPartionCellId_old_11, vbPartionCellId_old_12, vbPartionCellId_old_13, vbPartionCellId_old_14, vbPartionCellId_old_15
            , vbPartionCellId_old_16, vbPartionCellId_old_17, vbPartionCellId_old_18, vbPartionCellId_old_19, vbPartionCellId_old_20
            , vbPartionCellId_old_21, vbPartionCellId_old_22
            , vbIsClose_1, vbIsClose_2, vbIsClose_3, vbIsClose_4, vbIsClose_5, vbIsClose_6, vbIsClose_7, vbIsClose_8, vbIsClose_9, vbIsClose_10
            , vbIsClose_11, vbIsClose_12, vbIsClose_13, vbIsClose_14, vbIsClose_15, vbIsClose_16, vbIsClose_17, vbIsClose_18, vbIsClose_19, vbIsClose_20
            , vbIsClose_21, vbIsClose_22

         FROM lpUpdate_MI_Send_byReport_all (inUnitId                := inUnitId
                                           , inStartDate             := inStartDate
                                           , inEndDate               := inEndDate
                                           , inGoodsId               := inGoodsId
                                           , inGoodsKindId           := inGoodsKindId
                                           , inPartionGoodsDate      := inPartionGoodsDate
                                           , inPartionCellId_1       := ioPartionCellId_1
                                           , inPartionCellId_2       := ioPartionCellId_2
                                           , inPartionCellId_3       := ioPartionCellId_3
                                           , inPartionCellId_4       := ioPartionCellId_4
                                           , inPartionCellId_5       := ioPartionCellId_5
                                           , inPartionCellId_6       := ioPartionCellId_6
                                           , inPartionCellId_7       := ioPartionCellId_7
                                           , inPartionCellId_8       := ioPartionCellId_8
                                           , inPartionCellId_9       := ioPartionCellId_9
                                           , inPartionCellId_10      := ioPartionCellId_10
                                           , inPartionCellId_11      := ioPartionCellId_11
                                           , inPartionCellId_12      := ioPartionCellId_12
                                           , inPartionCellId_13      := ioPartionCellId_13
                                           , inPartionCellId_14      := ioPartionCellId_14
                                           , inPartionCellId_15      := ioPartionCellId_15
                                           , inPartionCellId_16      := ioPartionCellId_16
                                           , inPartionCellId_17      := ioPartionCellId_17
                                           , inPartionCellId_18      := ioPartionCellId_18
                                           , inPartionCellId_19      := ioPartionCellId_19
                                           , inPartionCellId_20      := ioPartionCellId_20
                                           , inPartionCellId_21      := ioPartionCellId_21
                                           , inPartionCellId_22      := ioPartionCellId_22

                                           , inPartionCellId_1_new   := vbPartionCellId_1
                                           , inPartionCellId_2_new   := vbPartionCellId_2
                                           , inPartionCellId_3_new   := vbPartionCellId_3
                                           , inPartionCellId_4_new   := vbPartionCellId_4
                                           , inPartionCellId_5_new   := vbPartionCellId_5
                                           , inPartionCellId_6_new   := vbPartionCellId_6
                                           , inPartionCellId_7_new   := vbPartionCellId_7
                                           , inPartionCellId_8_new   := vbPartionCellId_8
                                           , inPartionCellId_9_new   := vbPartionCellId_9
                                           , inPartionCellId_10_new  := vbPartionCellId_10
                                           , inPartionCellId_11_new  := vbPartionCellId_11
                                           , inPartionCellId_12_new  := vbPartionCellId_12
                                           , inPartionCellId_13_new  := vbPartionCellId_13
                                           , inPartionCellId_14_new  := vbPartionCellId_14
                                           , inPartionCellId_15_new  := vbPartionCellId_15
                                           , inPartionCellId_16_new  := vbPartionCellId_16
                                           , inPartionCellId_17_new  := vbPartionCellId_17
                                           , inPartionCellId_18_new  := vbPartionCellId_18
                                           , inPartionCellId_19_new  := vbPartionCellId_19
                                           , inPartionCellId_20_new  := vbPartionCellId_20
                                           , inPartionCellId_21_new  := vbPartionCellId_21
                                           , inPartionCellId_22_new  := vbPartionCellId_22
                                           , inUserId                := vbUserId
                                            ) AS tmp;

     END IF;

     --outPartionCellId_last := COALESCE (vbPartionCellId_1, vbPartionCellId_2, vbPartionCellId_3, vbPartionCellId_4, vbPartionCellId_5, vbPartionCellId_6, vbPartionCellId_7, vbPartionCellId_8, vbPartionCellId_9, vbPartionCellId_10, 0);
     IF     COALESCE(ioPartionCellId_1,0) <> COALESCE (vbPartionCellId_1, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_1, 0);
     ELSEIF COALESCE(ioPartionCellId_2,0) <> COALESCE (vbPartionCellId_2, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_2, 0);
     ELSEIF COALESCE(ioPartionCellId_3,0) <> COALESCE (vbPartionCellId_3, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_3, 0);
     ELSEIF COALESCE(ioPartionCellId_4,0) <> COALESCE (vbPartionCellId_4, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_4, 0);
     ELSEIF COALESCE(ioPartionCellId_5,0) <> COALESCE (vbPartionCellId_5, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_5, 0);
     ELSEIF COALESCE(ioPartionCellId_6,0) <> COALESCE (vbPartionCellId_6, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_6, 0);
     ELSEIF COALESCE(ioPartionCellId_7,0) <> COALESCE (vbPartionCellId_7, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_7, 0);
     ELSEIF COALESCE(ioPartionCellId_8,0) <> COALESCE (vbPartionCellId_8, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_8, 0);
     ELSEIF COALESCE(ioPartionCellId_9,0) <> COALESCE (vbPartionCellId_9, 0) THEN outPartionCellId_last := COALESCE (vbPartionCellId_9, 0);
     ELSEIF COALESCE(ioPartionCellId_10,0)<> COALESCE (vbPartionCellId_10, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_10, 0);
     ELSEIF COALESCE(ioPartionCellId_11,0)<> COALESCE (vbPartionCellId_11, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_11, 0);
     ELSEIF COALESCE(ioPartionCellId_12,0)<> COALESCE (vbPartionCellId_12, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_12, 0);
     ELSEIF COALESCE(ioPartionCellId_13,0)<> COALESCE (vbPartionCellId_13, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_13, 0);
     ELSEIF COALESCE(ioPartionCellId_14,0)<> COALESCE (vbPartionCellId_14, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_14, 0);
     ELSEIF COALESCE(ioPartionCellId_15,0)<> COALESCE (vbPartionCellId_15, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_15, 0);
     ELSEIF COALESCE(ioPartionCellId_16,0)<> COALESCE (vbPartionCellId_16, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_16, 0);
     ELSEIF COALESCE(ioPartionCellId_17,0)<> COALESCE (vbPartionCellId_17, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_17, 0);
     ELSEIF COALESCE(ioPartionCellId_18,0)<> COALESCE (vbPartionCellId_18, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_18, 0);
     ELSEIF COALESCE(ioPartionCellId_19,0)<> COALESCE (vbPartionCellId_19, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_19, 0);
     ELSEIF COALESCE(ioPartionCellId_20,0)<> COALESCE (vbPartionCellId_20, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_20, 0);
     ELSEIF COALESCE(ioPartionCellId_21,0)<> COALESCE (vbPartionCellId_21, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_21, 0);
     ELSEIF COALESCE(ioPartionCellId_22,0)<> COALESCE (vbPartionCellId_22, 0) THEN outPartionCellId_last:= COALESCE (vbPartionCellId_22, 0);
     END IF;


     -- ≈сли поставили ячейку ќтбор
     IF (COALESCE (ioPartionCellId_1, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_1 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_2, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_2 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_3, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_3 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_4, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_4 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_5, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_5 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_6, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_6 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_7, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_7 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_8, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_8 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_9, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_9 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_10, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_10 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_11, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_11 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_12, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_12 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_13, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_13 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_14, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_14 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_15, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_15 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_16, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_16 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_17, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_17 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_18, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_18 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_19, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_19 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_20, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_20 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_21, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_21 = zc_PartionCell_RK())
     OR (COALESCE (ioPartionCellId_22, 0) <> COALESCE (vbPartionCellId_1, 0) AND vbPartionCellId_22 = zc_PartionCell_RK())
     THEN
         ioIsChoiceCell_mi:= FALSE;
         --
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), lpSelect.MovementItemId, FALSE)
                 -- сохранили св€зь с <>
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), lpSelect.MovementItemId, vbUserId)
                 -- сохранили свойство <>
               , lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), lpSelect.MovementItemId, CURRENT_TIMESTAMP)

         FROM -- ћеста отбора дл€ хранени€
              (SELECT lpSelect.MovementItemId
               FROM lpSelect_Movement_ChoiceCell_mi (vbUserId) AS lpSelect
               WHERE lpSelect.GoodsId     = inGoodsId
                 AND lpSelect.GoodsKindId = inGoodsKindId
              ) AS lpSelect;

     END IF;


     -- пареметр дл€ печати
     outIsPrint := CASE WHEN COALESCE (outPartionCellId_last,0) IN (0, zc_PartionCell_RK(), zc_PartionCell_RK(), zc_PartionCell_Err()) THEN FALSE ELSE TRUE END;

     -- вернули Id
     ioPartionCellId_1 := CASE WHEN vbPartionCellId_old_1 > 0 THEN vbPartionCellId_old_1 ELSE vbPartionCellId_1 END;
     ioPartionCellId_2 := CASE WHEN vbPartionCellId_old_2 > 0 THEN vbPartionCellId_old_2 ELSE vbPartionCellId_2 END;
     ioPartionCellId_3 := CASE WHEN vbPartionCellId_old_3 > 0 THEN vbPartionCellId_old_3 ELSE vbPartionCellId_3 END;
     ioPartionCellId_4 := CASE WHEN vbPartionCellId_old_4 > 0 THEN vbPartionCellId_old_4 ELSE vbPartionCellId_4 END;
     ioPartionCellId_5 := CASE WHEN vbPartionCellId_old_5 > 0 THEN vbPartionCellId_old_5 ELSE vbPartionCellId_5 END;
     ioPartionCellId_6 := CASE WHEN vbPartionCellId_old_6 > 0 THEN vbPartionCellId_old_6 ELSE vbPartionCellId_6 END;
     ioPartionCellId_7 := CASE WHEN vbPartionCellId_old_7 > 0 THEN vbPartionCellId_old_7 ELSE vbPartionCellId_7 END;
     ioPartionCellId_8 := CASE WHEN vbPartionCellId_old_8 > 0 THEN vbPartionCellId_old_8 ELSE vbPartionCellId_8 END;
     ioPartionCellId_9 := CASE WHEN vbPartionCellId_old_9 > 0 THEN vbPartionCellId_old_9 ELSE vbPartionCellId_9 END;
     ioPartionCellId_10:= CASE WHEN vbPartionCellId_old_10 > 0 THEN vbPartionCellId_old_10 ELSE vbPartionCellId_10 END;
     ioPartionCellId_11:= CASE WHEN vbPartionCellId_old_11 > 0 THEN vbPartionCellId_old_11 ELSE vbPartionCellId_11 END;
     ioPartionCellId_12:= CASE WHEN vbPartionCellId_old_12 > 0 THEN vbPartionCellId_old_12 ELSE vbPartionCellId_12 END;
     ioPartionCellId_13 :=CASE WHEN vbPartionCellId_old_13 > 0 THEN vbPartionCellId_old_13 ELSE vbPartionCellId_13 END;
     ioPartionCellId_14 :=CASE WHEN vbPartionCellId_old_14 > 0 THEN vbPartionCellId_old_14 ELSE vbPartionCellId_14 END;
     ioPartionCellId_15 :=CASE WHEN vbPartionCellId_old_15 > 0 THEN vbPartionCellId_old_15 ELSE vbPartionCellId_15 END;
     ioPartionCellId_16 :=CASE WHEN vbPartionCellId_old_16 > 0 THEN vbPartionCellId_old_16 ELSE vbPartionCellId_16 END;
     ioPartionCellId_17 :=CASE WHEN vbPartionCellId_old_17 > 0 THEN vbPartionCellId_old_17 ELSE vbPartionCellId_17 END;
     ioPartionCellId_18 :=CASE WHEN vbPartionCellId_old_18 > 0 THEN vbPartionCellId_old_18 ELSE vbPartionCellId_18 END;
     ioPartionCellId_19 :=CASE WHEN vbPartionCellId_old_19 > 0 THEN vbPartionCellId_old_19 ELSE vbPartionCellId_19 END;
     ioPartionCellId_20:= CASE WHEN vbPartionCellId_old_20 > 0 THEN vbPartionCellId_old_20 ELSE vbPartionCellId_20 END;
     ioPartionCellId_21:= CASE WHEN vbPartionCellId_old_21 > 0 THEN vbPartionCellId_old_21 ELSE vbPartionCellId_21 END;
     ioPartionCellId_22:= CASE WHEN vbPartionCellId_old_22 > 0 THEN vbPartionCellId_old_22 ELSE vbPartionCellId_22 END;

     -- вернули Name
     ioPartionCellName_1  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_1, vbPartionCellId_1)), vbIsClose_1);
     ioPartionCellName_2  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_2, vbPartionCellId_2)), vbIsClose_2);
     ioPartionCellName_3  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_3, vbPartionCellId_3)), vbIsClose_3);
     ioPartionCellName_4  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_4, vbPartionCellId_4)), vbIsClose_4);
     ioPartionCellName_5  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_5, vbPartionCellId_5)), vbIsClose_5);
     ioPartionCellName_6  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_6, vbPartionCellId_6)), vbIsClose_6);
     ioPartionCellName_7  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_7, vbPartionCellId_7)), vbIsClose_7);
     ioPartionCellName_8  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_8, vbPartionCellId_8)), vbIsClose_8);
     ioPartionCellName_9  := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_9, vbPartionCellId_9)), vbIsClose_9);
     ioPartionCellName_10 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_10,vbPartionCellId_10)),vbIsClose_10);
     ioPartionCellName_11 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_11,vbPartionCellId_11)),vbIsClose_11);
     ioPartionCellName_12 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_12,vbPartionCellId_12)),vbIsClose_12);
     ioPartionCellName_13 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_13,vbPartionCellId_13)),vbIsClose_13);
     ioPartionCellName_14 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_14,vbPartionCellId_14)),vbIsClose_14);
     ioPartionCellName_15 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_15,vbPartionCellId_15)),vbIsClose_15);
     ioPartionCellName_16 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_16,vbPartionCellId_16)),vbIsClose_16);
     ioPartionCellName_17 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_17,vbPartionCellId_17)),vbIsClose_17);
     ioPartionCellName_18 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_18,vbPartionCellId_18)),vbIsClose_18);
     ioPartionCellName_19 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_19,vbPartionCellId_19)),vbIsClose_19);
     ioPartionCellName_20 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_20,vbPartionCellId_20)),vbIsClose_20);
     ioPartionCellName_21 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_21,vbPartionCellId_21)),vbIsClose_21);
     ioPartionCellName_22 := zfCalc_PartionCell_IsClose ((SELECT /*Object.ObjectCode :: TVarChar || ' ' ||*/ Object.ValueData FROM Object WHERE Object.Id = COALESCE (vbPartionCellId_old_22,vbPartionCellId_22)),vbIsClose_22);


   -- сохранили протокол
     --PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 »—“ќ–»я –ј«–јЅќ“ »: ƒј“ј, ј¬“ќ–
               ‘елонюк ».¬.    ухтин ».¬.    лиментьев  .».

 04.01.24         *
*/

-- тест
--