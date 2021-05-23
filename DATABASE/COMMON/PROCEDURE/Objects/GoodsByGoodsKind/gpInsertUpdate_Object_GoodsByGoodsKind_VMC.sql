-- Function: gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_VMC (Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , Boolean, Boolean, Boolean
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind_VMC(
 INOUT ioId                    Integer  , -- ���� ������� <�����>
    IN inGoodsId               Integer  , -- ������
    IN inGoodsKindId           Integer  , -- ���� �������
    IN inGoodsId_sh            Integer  , -- ����� (�� ��������� "�������")
    IN inGoodsKindId_sh        Integer  , -- ��� ������ (�� ��������� "�������")
    IN inBoxId                 Integer  , -- ���� (E2/E3)
    IN inBoxId_2               Integer  , -- ���� (�����)
    --IN inWeightMin             TFloat  , -- ���. ���
    --IN inWeightMax             TFloat  , -- ���. ���
    IN inHeight                TFloat  , -- ������
    IN inLength                TFloat  , -- �����
    IN inWidth                 TFloat  , -- ������
    IN inNormInDays            TFloat  , -- C��� ��������, ��.
    IN inCountOnBox            TFloat  , -- ���-�� ��. � ��. (E2/E3)
    IN inWeightOnBox           TFloat  , -- ���-�� ��. � ��. (E2/E3)
    IN inCountOnBox_2          TFloat  , -- ���-�� ��. � ��. (�����)
    IN inWeightOnBox_2         TFloat  , -- ���-�� ��. � ��. (�����)

   OUT outWeightGross_sh       TFloat  , -- ��� ������ ������� ����� (E2/E3)
   OUT outWeightGross_nom      TFloat  , -- ��� ������ ������� ����� (E2/E3)
   OUT outWeightGross_ves      TFloat  , -- ��� ������ ������� ����� (E2/E3)

   OUT outWeightOnBox          TFloat  , -- ���-�� ��. � ��. (E2/E3)

   OUT outWeightAvgGross_sh    TFloat  , -- ��� ������ �� �������� ���� ����� (E2/E3)
   OUT outWeightAvgGross_nom   TFloat  , -- ��� ������ �� �������� ���� ����� (E2/E3)
   OUT outWeightAvgGross_ves   TFloat  , -- ��� ������ �� �������� ���� ����� (E2/E3)

   OUT outWeightAvgNet_sh      TFloat  , -- ��� ����� �� �������� ���� ����� (E2/E3)
   OUT outWeightAvgNet_nom     TFloat  , -- ��� ����� �� �������� ���� ����� (E2/E3)
   OUT outWeightAvgNet_ves     TFloat  , -- ��� ����� �� �������� ���� ����� (E2/E3)

   OUT outWeightGross_2        TFloat  , -- ��� ������ ������� ����� (�����)
   OUT outWeightOnBox_2        TFloat  , -- ���-�� ��. � �� (�����)
   OUT outWeightAvgGross_2     TFloat  , -- ��� ������ �� �������� ���� ����� (�����)
   OUT outWeightAvgNet_2       TFloat  , -- ��� ����� �� �������� ���� ����� (�����)

    IN inWeightAvg_Sh          TFloat ,
    IN inWeightAvg_Nom         TFloat ,
    IN inWeightAvg_Ves         TFloat ,
    IN inTax_Sh                TFloat ,
    IN inTax_Nom               TFloat ,
    IN inTax_Ves               TFloat ,

   OUT outWeightMin_Sh         TFloat,
   OUT outWeightMax_Sh         TFloat,
   OUT outWeightMin_Nom        TFloat,
   OUT outWeightMax_Nom        TFloat,
   OUT outWeightMin_Ves        TFloat,
   OUT outWeightMax_Ves        TFloat,

    IN inisGoodsTypeKind_Sh    Boolean , -- �������
    IN inisGoodsTypeKind_Nom   Boolean , -- �����������
    IN inisGoodsTypeKind_Ves   Boolean , -- �������������
   OUT outisCodeCalc_Diff      Boolean , -- ������ ���� ���
   OUT outCodeCalc_Sh          TVarChar, -- ��� ��� ��.
   OUT outCodeCalc_Nom         TVarChar, -- ��� ��� �������
   OUT outCodeCalc_Ves         TVarChar, -- ��� ��� ���������
   OUT outWmsCode              Integer , -- ����� ��� ���*
   OUT outWmsCodeCalc_Sh       TVarChar, -- ����� ��� ���* ��.
   OUT outWmsCodeCalc_Nom      TVarChar, -- ����� ��� ���* �������
   OUT outWmsCodeCalc_Ves      TVarChar, -- ����� ��� ���* ���������

    IN inWmsCellNum                Integer  , -- � ������ �� ������ ���

    IN inRetail1Id                 Integer  , -- ���� 1
    IN inRetail2Id                 Integer  , -- ���� 2
    IN inRetail3Id                 Integer  , -- ���� 3
    IN inRetail4Id                 Integer  , -- ���� 4
    IN inRetail5Id                 Integer  , -- ���� 5
    IN inRetail6Id                 Integer  , -- ���� 6
 INOUT ioBoxId_Retail1             Integer  , -- ���� ��� ���� 1
 INOUT ioBoxId_Retail2             Integer  , -- ���� ��� ���� 2
 INOUT ioBoxId_Retail3             Integer  , -- ���� ��� ���� 3
 INOUT ioBoxId_Retail4             Integer  , -- ���� ��� ���� 4
 INOUT ioBoxId_Retail5             Integer  , -- ���� ��� ���� 5
 INOUT ioBoxId_Retail6             Integer  , -- ���� ��� ���� 6
   OUT outBoxName_Retail1          TVarChar , -- ���� �������� ��� ���� 1
   OUT outBoxName_Retail2          TVarChar , -- ���� �������� ��� ���� 2
   OUT outBoxName_Retail3          TVarChar , -- ���� �������� ��� ���� 3
   OUT outBoxName_Retail4          TVarChar , -- ���� �������� ��� ���� 4
   OUT outBoxName_Retail5          TVarChar , -- ���� �������� ��� ���� 5
   OUT outBoxName_Retail6          TVarChar , -- ���� �������� ��� ���� 6
 INOUT ioCountOnBox_Retail1        TFloat   , -- ���������� ��. � ��. ��� ���� 1
 INOUT ioCountOnBox_Retail2        TFloat   , -- ���������� ��. � ��. ��� ���� 2
 INOUT ioCountOnBox_Retail3        TFloat   , -- ���������� ��. � ��. ��� ���� 3
 INOUT ioCountOnBox_Retail4        TFloat   , -- ���������� ��. � ��. ��� ���� 4
 INOUT ioCountOnBox_Retail5        TFloat   , -- ���������� ��. � ��. ��� ���� 5
 INOUT ioCountOnBox_Retail6        TFloat   , -- ���������� ��. � ��. ��� ���� 6

 INOUT ioWeightOnBox_Retail1       TFloat   , -- ���������� ��. � ��. ��� ���� 1
 INOUT ioWeightOnBox_Retail2       TFloat   , -- ���������� ��. � ��. ��� ���� 2
 INOUT ioWeightOnBox_Retail3       TFloat   , -- ���������� ��. � ��. ��� ���� 3
 INOUT ioWeightOnBox_Retail4       TFloat   , -- ���������� ��. � ��. ��� ���� 4
 INOUT ioWeightOnBox_Retail5       TFloat   , -- ���������� ��. � ��. ��� ���� 5
 INOUT ioWeightOnBox_Retail6       TFloat   , -- ���������� ��. � ��. ��� ���� 6

    IN inSession               TVarChar
)

RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbGoodsPropertyBoxId    Integer;
   DECLARE vbWmsCode               Integer;
   DECLARE vbBoxId_Retail          Integer;
   DECLARE vbGoodsPropertyValueId  Integer;
   DECLARE vbGoodsByGoodsKindId_sh Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_VMC());

--RAISE EXCEPTION '������.  <%>.', ioBoxId_Retail2;
   -- �������� ������������
   IF EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
              FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                        ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
              WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId <> COALESCE (ioId, 0))
   THEN
       RAISE EXCEPTION '������.��������  <%> + <%> ��� ���� � �����������. ������������ ���������.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
   END IF;


   -- �������� - ��� � ����� ������ �� �����
   IF vbUserId = 5
   THEN
       RAISE EXCEPTION '������.��� ���� - ��� � ����� ������ �� �����.';
   END IF;


   IF COALESCE (ioId, 0) = 0
   THEN
       -- ��������� <������>
       ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsByGoodsKind(), 0, '');
       -- ��������� ����� � <������>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods(), ioId, inGoodsId);

       -- ��������� ����� � <���� �������>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind(), ioId, inGoodsKindId);

   ELSE
       -- ��������
       IF NOT EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                      FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                               AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                      WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                        AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                        AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                        AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId = ioId)
       THEN
           RAISE EXCEPTION '������.��� ���� �������� �������� <��� ��������>.';
       END IF;

   END IF;

   -- ��������� �������� <>
   --PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightMin(), ioId, inWeightMin);
   -- ��������� �������� <>
   --PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightMax(), ioId, inWeightMax);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Height(), ioId, inHeight);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Length(), ioId, inLength);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Width(), ioId, inWidth);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_NormInDays(), ioId, inNormInDays);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WmsCellNum(), ioId, inWmsCellNum);


   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh(), ioId, inWeightAvg_Sh);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom(), ioId, inWeightAvg_Nom);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves(), ioId, inWeightAvg_Ves);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh(), ioId, inTax_Sh);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Tax_Nom(), ioId, inTax_Nom);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Tax_Ves(), ioId, inTax_Ves);


   -- ��������� ����� � <����� (�� ��������� "�������")>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods_Sh(), ioId, inGoodsId_sh);
   -- ��������� ����� � <��� ������ (�� ��������� "�������")>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind_Sh(), ioId, inGoodsKindId_sh);

   IF inisGoodsTypeKind_Sh = TRUE
   THEN
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh(), ioId, zc_Enum_GoodsTypeKind_Sh());

       IF inGoodsId_sh > 0
       THEN
           -- ��������
           IF COALESCE (inGoodsKindId_sh, 0) = 0
           THEN
               RAISE EXCEPTION '������.�� ���������� <�������������� ��� ������ (�� ���."�������")>.';
           END IF;

           -- ����� ���� �������������� - ������ ��� ��������� ��.
           vbGoodsByGoodsKindId_sh:= (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                      FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                                ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                               AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                      WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId                          = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                        AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   = inGoodsId_sh
                                        AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = inGoodsKindId_sh
                                     );
           --
           PERFORM gpUpdate_Object_GoodsByGoodsKind_GoodsTypeKind_Sh (inId                 := vbGoodsByGoodsKindId_sh
                                                                    , inGoodsId            := inGoodsId_sh
                                                                    , inGoodsKindId        := inGoodsKindId_sh
                                                                    , inIsGoodsTypeKind_Sh := TRUE
                                                                    , inSession            := inSession
                                                                     );
           -- ���� ��� Insert
           IF COALESCE (vbGoodsByGoodsKindId_sh, 0) = 0
           THEN
               -- ��� ��� - ����� ���� �������������� - ������ ��� ��������� ��.
               vbGoodsByGoodsKindId_sh:= (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                          FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                               LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                                    ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                          WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId                          = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                            AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   = inGoodsId_sh
                                            AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = inGoodsKindId_sh
                                         );
           END IF;

           -- ��������� �������� <>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh(), vbGoodsByGoodsKindId_sh, inWeightAvg_Sh);
           -- ��������� �������� <>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Tax_Sh(), vbGoodsByGoodsKindId_sh, inTax_Sh);

       END IF;

   ELSE
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh(), ioId, Null);
   END IF;
   IF inisGoodsTypeKind_Nom = TRUE
   THEN
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom(), ioId, zc_Enum_GoodsTypeKind_Nom());
   ELSE
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom(), ioId, Null);
   END IF;
   IF inisGoodsTypeKind_Ves = TRUE
   THEN
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves(), ioId, zc_Enum_GoodsTypeKind_Ves());
   ELSE
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves(), ioId, Null);
   END IF;


   -- WmsCode
   IF inisGoodsTypeKind_Sh = TRUE OR inisGoodsTypeKind_Nom = TRUE OR inisGoodsTypeKind_Ves = TRUE
   THEN
       IF NOT EXISTS (SELECT ObjectFloat.ValueData
                      FROM ObjectFloat
                      WHERE ObjectFloat.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()
                        AND ObjectFloat.ObjectId = ioId
                        AND ObjectFloat.ValueData <> 0
                      )
       THEN
           -- ������� ���� ��� + 1
           vbWmsCode := (COALESCE ( (SELECT MAX (ObjectFloat.ValueData) FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()),0) + 1 ) :: Integer;
           -- ���������� ����� ��� = ���������� ���� + 1
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WmsCode(), ioId, vbWmsCode);
       END IF;
   END IF;


   -- ���� ������ ���� 1 ����� ��������� ������
   IF COALESCE (inBoxId,0) <> 0
   THEN
       -- �������� ��� � �������� ����2 - ������ ����2
       IF inBoxId NOT IN (zc_Box_E2(), zc_Box_E3())
       THEN
           RAISE EXCEPTION '������.��������  <%> �� ����� ���� �������� � �������� <���� �2/�3>.', lfGet_Object_ValueData (inBoxId);
       END IF;
       -- ������� ���� ���� GoodsPropertyBox.Id
       vbGoodsPropertyBoxId := (SELECT ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                FROM ObjectLink AS ObjectLink_GoodsPropertyBox_Goods
                                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_GoodsKind
                                                           ON ObjectLink_GoodsPropertyBox_GoodsKind.ObjectId = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                                          AND ObjectLink_GoodsPropertyBox_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
                                                          AND ObjectLink_GoodsPropertyBox_GoodsKind.ChildObjectId = inGoodsKindId
                                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Box
                                                           ON ObjectLink_GoodsPropertyBox_Box.ObjectId = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                                          AND ObjectLink_GoodsPropertyBox_Box.DescId = zc_ObjectLink_GoodsPropertyBox_Box()
                                                          AND ObjectLink_GoodsPropertyBox_Box.ChildObjectId IN (zc_Box_E2(), zc_Box_E3())
                                     INNER JOIN Object AS Object_GoodsPropertyBox
                                                       ON Object_GoodsPropertyBox.Id = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                                      AND Object_GoodsPropertyBox.DescId = zc_Object_GoodsPropertyBox()
                                                      --AND Object_GoodsPropertyBox.isErased = FALSE
                                WHERE ObjectLink_GoodsPropertyBox_Goods.DescId = zc_ObjectLink_GoodsPropertyBox_Goods()
                                  AND ObjectLink_GoodsPropertyBox_Goods.ChildObjectId = inGoodsId
                                LIMIT 1
                                );

       --���� ���� GoodsPropertyBox.Id � �� ������� �� ����. ����� ��� ���������������
       IF COALESCE (vbGoodsPropertyBoxId,0) <> 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbGoodsPropertyBoxId AND Object.isErased = TRUE)
       THEN
           --
           PERFORM lpUpdate_Object_isErased (inObjectId:= vbGoodsPropertyBoxId, inUserId:= vbUserId);
       END IF;

       -- ��������� �������� ������� ������� ��� ������
       PERFORM gpInsertUpdate_Object_GoodsPropertyBox (ioId                   := COALESCE (vbGoodsPropertyBoxId,0) , -- ���� ������� <>
                                                       inBoxId                := inBoxId        , -- ����
                                                       inGoodsId              := inGoodsId      , -- ������
                                                       inGoodsKindId          := inGoodsKindId  , -- ���� �������
                                                       inCountOnBox           := inCountOnBox   , -- ���������� ��. � ��.
                                                       inWeightOnBox          := inWeightOnBox  , -- ���������� ��. � ��.
                                                       inSession              := inSession);

      /* outWeightGross := inWeightOnBox + (SELECT ObjectFloat_Weight.ValueData
                                          FROM ObjectFloat AS ObjectFloat_Weight
                                          WHERE ObjectFloat_Weight.ObjectId = inBoxId
                                            AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Box_Weight()
                                          );
      */

   END IF;

   -- ���� ������ ���� 2 ����� ��������� ������
   IF COALESCE (inBoxId_2,0) <> 0
   THEN
       -- �������� ��� � �������� ����2 - ������ ����2
       IF inBoxId_2 IN (zc_Box_E2(), zc_Box_E3())
       THEN
           RAISE EXCEPTION '������.�������� <%> �� ����� ���� �������� � �������� <���������>.', lfGet_Object_ValueData (inBoxId_2);
       END IF;

       -- ������� ���� ���� GoodsPropertyBox.Id
       vbGoodsPropertyBoxId := (SELECT ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                FROM ObjectLink AS ObjectLink_GoodsPropertyBox_Goods
                                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_GoodsKind
                                                           ON ObjectLink_GoodsPropertyBox_GoodsKind.ObjectId = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                                          AND ObjectLink_GoodsPropertyBox_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
                                                          AND ObjectLink_GoodsPropertyBox_GoodsKind.ChildObjectId = inGoodsKindId
                                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Box
                                                           ON ObjectLink_GoodsPropertyBox_Box.ObjectId = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                                          AND ObjectLink_GoodsPropertyBox_Box.DescId = zc_ObjectLink_GoodsPropertyBox_Box()
                                                          AND ObjectLink_GoodsPropertyBox_Box.ChildObjectId NOT IN (zc_Box_E2(), zc_Box_E3())
                                     INNER JOIN Object AS Object_GoodsPropertyBox
                                                       ON Object_GoodsPropertyBox.Id = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                                      AND Object_GoodsPropertyBox.DescId = zc_Object_GoodsPropertyBox()
                                                      --AND Object_GoodsPropertyBox.isErased = FALSE
                                WHERE ObjectLink_GoodsPropertyBox_Goods.DescId = zc_ObjectLink_GoodsPropertyBox_Goods()
                                  AND ObjectLink_GoodsPropertyBox_Goods.ChildObjectId = inGoodsId
                                LIMIT 1
                                );

       --���� ���� GoodsPropertyBox.Id � �� ������� �� ����. ����� ��� ���������������
       IF COALESCE (vbGoodsPropertyBoxId,0) <> 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbGoodsPropertyBoxId AND Object.isErased = TRUE)
       THEN
           --
           PERFORM lpUpdate_Object_isErased (inObjectId:= vbGoodsPropertyBoxId, inUserId:= vbUserId);
       END IF;

       -- ��������� �������� ������� ������� ��� ������
       PERFORM gpInsertUpdate_Object_GoodsPropertyBox (ioId                   := COALESCE (vbGoodsPropertyBoxId,0) , -- ���� ������� <>
                                                       inBoxId                := inBoxId_2        , -- ����
                                                       inGoodsId              := inGoodsId        , -- ������
                                                       inGoodsKindId          := inGoodsKindId    , -- ���� �������
                                                       inCountOnBox           := inCountOnBox_2   , -- ���������� ��. � ��.
                                                       inWeightOnBox          := inWeightOnBox_2  , -- ���������� ��. � ��.
                                                       inSession              := inSession);

       /*outWeightGross_2 := inWeightOnBox_2 + (SELECT ObjectFloat_Weight.ValueData
                                              FROM ObjectFloat AS ObjectFloat_Weight
                                              WHERE ObjectFloat_Weight.ObjectId = inBoxId_2
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Box_Weight()
                                              );
      */
   END IF;


   --- c������� GoodsPropertyValue ����� ��� �����
   IF COALESCE (inRetail1Id,0) = 0 AND (COALESCE (ioBoxId_Retail1,0) <> 0 OR COALESCE (ioCountOnBox_Retail1,0) <> 0 OR COALESCE (ioWeightOnBox_Retail1,0) <> 0) THEN ioBoxId_Retail1:= 0; outBoxName_Retail1:= ''; ioCountOnBox_Retail1:= 0; ioWeightOnBox_Retail1:= 0; RAISE EXCEPTION '������.�� ���������� �������� ���� 1.'; END IF;
   IF COALESCE (inRetail2Id,0) = 0 AND (COALESCE (ioBoxId_Retail2,0) <> 0 OR COALESCE (ioCountOnBox_Retail2,0) <> 0 OR COALESCE (ioWeightOnBox_Retail2,0) <> 0) THEN ioBoxId_Retail2:= 0; outBoxName_Retail2:= ''; ioCountOnBox_Retail2:= 0; ioWeightOnBox_Retail2:= 0; RAISE EXCEPTION '������.�� ���������� �������� ���� 2.'; END IF;
   IF COALESCE (inRetail3Id,0) = 0 AND (COALESCE (ioBoxId_Retail3,0) <> 0 OR COALESCE (ioCountOnBox_Retail3,0) <> 0 OR COALESCE (ioWeightOnBox_Retail3,0) <> 0) THEN ioBoxId_Retail3:= 0; outBoxName_Retail3:= ''; ioCountOnBox_Retail3:= 0; ioWeightOnBox_Retail3:= 0; RAISE EXCEPTION '������.�� ���������� �������� ���� 3.'; END IF;
   IF COALESCE (inRetail4Id,0) = 0 AND (COALESCE (ioBoxId_Retail4,0) <> 0 OR COALESCE (ioCountOnBox_Retail4,0) <> 0 OR COALESCE (ioWeightOnBox_Retail4,0) <> 0) THEN ioBoxId_Retail4:= 0; outBoxName_Retail4:= ''; ioCountOnBox_Retail4:= 0; ioWeightOnBox_Retail4:= 0; RAISE EXCEPTION '������.�� ���������� �������� ���� 4.'; END IF;
   IF COALESCE (inRetail5Id,0) = 0 AND (COALESCE (ioBoxId_Retail5,0) <> 0 OR COALESCE (ioCountOnBox_Retail5,0) <> 0 OR COALESCE (ioWeightOnBox_Retail5,0) <> 0) THEN ioBoxId_Retail5:= 0; outBoxName_Retail5:= ''; ioCountOnBox_Retail5:= 0; ioWeightOnBox_Retail5:= 0; RAISE EXCEPTION '������.�� ���������� �������� ���� 5.'; END IF;
   IF COALESCE (inRetail6Id,0) = 0 AND (COALESCE (ioBoxId_Retail6,0) <> 0 OR COALESCE (ioCountOnBox_Retail6,0) <> 0 OR COALESCE (ioWeightOnBox_Retail6,0) <> 0) THEN ioBoxId_Retail6:= 0; outBoxName_Retail6:= ''; ioCountOnBox_Retail6:= 0; ioWeightOnBox_Retail6:= 0; RAISE EXCEPTION '������.�� ���������� �������� ���� 6.'; END IF;

   -- ������� ������ ��������� ����
   IF COALESCE (ioBoxId_Retail1,0) <> 0    --
   THEN
       vbBoxId_Retail := ioBoxId_Retail1;
   ELSE
       IF COALESCE (ioBoxId_Retail2,0) <> 0  --
       THEN
           vbBoxId_Retail := ioBoxId_Retail2;
       ELSE
           IF COALESCE (ioBoxId_Retail3,0) <> 0   --
           THEN
               vbBoxId_Retail := ioBoxId_Retail3;
           ELSE
               IF COALESCE (ioBoxId_Retail4,0) <> 0   --
               THEN
                   vbBoxId_Retail := ioBoxId_Retail4;
               ELSE
                   IF COALESCE (ioBoxId_Retail5,0) <> 0  --
                   THEN
                       vbBoxId_Retail := ioBoxId_Retail5;
                   ELSE
                       IF COALESCE (ioBoxId_Retail6,0) <> 0  --
                       THEN
                           vbBoxId_Retail := COALESCE (ioBoxId_Retail6,0);
                       END IF;
                   END IF;
               END IF;
           END IF;
       END IF;
   END IF;

   --
   IF COALESCE (inRetail1Id,0) <> 0
   THEN
       -- ��������� ���� 1 ����  = 1 ������������� ��-� �������
       IF EXISTS (SELECT COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId)
                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail1Id
                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                    AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                  GROUP BY ObjectLink_Juridical_Retail.ChildObjectId
                  HAVING COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId) > 1)
       THEN
           RAISE EXCEPTION '������. ���� <%> ������������� ����� ������ ��������������', lfGet_Object_ValueData (inRetail1Id);
       END IF;

       -- ������� GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM (SELECT DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                                                INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                        WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail1Id
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                                          AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                        ) AS tmpGoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  );
       IF COALESCE (vbGoodsPropertyValueId) <> 0
       THEN
           -- ��������� ����� � <����>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_Box(), vbGoodsPropertyValueId, vbBoxId_Retail);
           -- ��������� �������� <���������� ��. � ��.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_WeightOnBox(), vbGoodsPropertyValueId, ioWeightOnBox_Retail1);
           -- ��������� �������� <���������� ��. � ��.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_CountOnBox(), vbGoodsPropertyValueId, ioCountOnBox_Retail1);
       END IF;
       ioBoxId_Retail1 := vbBoxId_Retail;
       outBoxName_Retail1 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbBoxId_Retail);
   ELSE
       ioBoxId_Retail1 := 0;
       outBoxName_Retail1 := ''::TVarChar;
   END IF;
   --
   IF COALESCE (inRetail2Id,0) <> 0
   THEN
       -- ��������� ���� 1 ����  = 1 ������������� ��-� �������
       IF EXISTS (SELECT COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId)
                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail2Id
                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                    AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                  GROUP BY ObjectLink_Juridical_Retail.ChildObjectId
                  HAVING COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId) > 1)
       THEN
           RAISE EXCEPTION '������. ���� <%> ������������� ����� ������ ��������������', lfGet_Object_ValueData (inRetail2Id);
       END IF;

       -- ������� GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM (SELECT DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                                                INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                        WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail2Id
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                                          AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                        ) AS tmpGoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  );
       IF COALESCE (vbGoodsPropertyValueId) <> 0
       THEN
           -- ��������� ����� � <����>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_Box(), vbGoodsPropertyValueId, vbBoxId_Retail);
           -- ��������� �������� <���������� ��. � ��.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_WeightOnBox(), vbGoodsPropertyValueId, ioWeightOnBox_Retail2);
           -- ��������� �������� <���������� ��. � ��.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_CountOnBox(), vbGoodsPropertyValueId, ioCountOnBox_Retail2);
       END IF;
       ioBoxId_Retail2 := vbBoxId_Retail;
       outBoxName_Retail2 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbBoxId_Retail);
   ELSE
       ioBoxId_Retail2 := 0;
       outBoxName_Retail2 := ''::TVarChar;
   END IF;
   --
   IF COALESCE (inRetail3Id,0) <> 0
   THEN
       -- ��������� ���� 1 ����  = 1 ������������� ��-� �������
       IF EXISTS (SELECT COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId)
                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail3Id
                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                    AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                  GROUP BY ObjectLink_Juridical_Retail.ChildObjectId
                  HAVING COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId) > 1)
       THEN
           RAISE EXCEPTION '������. ���� <%> ������������� ����� ������ ��������������', lfGet_Object_ValueData (inRetail3Id);
       END IF;

       -- ������� GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM (SELECT DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                                                INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                        WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail3Id
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                                          AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                        ) AS tmpGoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  );
       IF COALESCE (vbGoodsPropertyValueId) <> 0
       THEN
           -- ��������� ����� � <����>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_Box(), vbGoodsPropertyValueId, vbBoxId_Retail);
           -- ��������� �������� <���������� ��. � ��.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_WeightOnBox(), vbGoodsPropertyValueId, ioWeightOnBox_Retail3);
           -- ��������� �������� <���������� ��. � ��.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_CountOnBox(), vbGoodsPropertyValueId, ioCountOnBox_Retail3);
       END IF;
       ioBoxId_Retail2 := vbBoxId_Retail;
       outBoxName_Retail3 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbBoxId_Retail);
   ELSE
       ioBoxId_Retail3 := 0;
       outBoxName_Retail3 := ''::TVarChar;
   END IF;
   --
   IF COALESCE (inRetail4Id,0) <> 0
   THEN
       -- ��������� ���� 1 ����  = 1 ������������� ��-� �������
       IF EXISTS (SELECT COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId)
                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail4Id
                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                    AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                  GROUP BY ObjectLink_Juridical_Retail.ChildObjectId
                  HAVING COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId) > 1)
       THEN
           RAISE EXCEPTION '������. ���� <%> ������������� ����� ������ ��������������', lfGet_Object_ValueData (inRetail4Id);
       END IF;

       -- ������� GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM (SELECT DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                                                INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                        WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail4Id
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                                          AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                        ) AS tmpGoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  );
       IF COALESCE (vbGoodsPropertyValueId) <> 0
       THEN
           -- ��������� ����� � <����>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_Box(), vbGoodsPropertyValueId, vbBoxId_Retail);
           -- ��������� �������� <���������� ��. � ��.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_WeightOnBox(), vbGoodsPropertyValueId, ioWeightOnBox_Retail4);
           -- ��������� �������� <���������� ��. � ��.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_CountOnBox(), vbGoodsPropertyValueId, ioCountOnBox_Retail4);
       END IF;
       ioBoxId_Retail4 := vbBoxId_Retail;
       outBoxName_Retail4 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbBoxId_Retail);
   ELSE
       ioBoxId_Retail4 := 0;
       outBoxName_Retail4 := ''::TVarChar;
   END IF;
   --
   IF COALESCE (inRetail5Id,0) <> 0
   THEN
       -- ��������� ���� 1 ����  = 1 ������������� ��-� �������
       IF EXISTS (SELECT COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId)
                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail5Id
                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                    AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                  GROUP BY ObjectLink_Juridical_Retail.ChildObjectId
                  HAVING COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId) > 1)
       THEN
           RAISE EXCEPTION '������. ���� <%> ������������� ����� ������ ��������������', lfGet_Object_ValueData (inRetail5Id);
       END IF;

       -- ������� GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM (SELECT DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                                                INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                        WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail5Id
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                                          AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                        ) AS tmpGoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  );
       IF COALESCE (vbGoodsPropertyValueId) <> 0
       THEN
           -- ��������� ����� � <����>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_Box(), vbGoodsPropertyValueId, vbBoxId_Retail);
           -- ��������� �������� <���������� ��. � ��.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_WeightOnBox(), vbGoodsPropertyValueId, ioWeightOnBox_Retail5);
           -- ��������� �������� <���������� ��. � ��.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_CountOnBox(), vbGoodsPropertyValueId, ioCountOnBox_Retail5);
       END IF;
       ioBoxId_Retail5 := vbBoxId_Retail;
       outBoxName_Retail5 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbBoxId_Retail);
   ELSE
       ioBoxId_Retail5 := 0;
       outBoxName_Retail5 := ''::TVarChar;
   END IF;
   --
   IF COALESCE (inRetail6Id,0) <> 0
   THEN
       -- ��������� ���� 1 ����  = 1 ������������� ��-� �������
       IF EXISTS (SELECT COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId)
                  FROM ObjectLink AS ObjectLink_Juridical_Retail
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                  WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail6Id
                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                    AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                  GROUP BY ObjectLink_Juridical_Retail.ChildObjectId
                  HAVING COUNT (DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId) > 1)
       THEN
           RAISE EXCEPTION '������. ���� <%> ������������� ����� ������ ��������������', lfGet_Object_ValueData (inRetail6Id);
       END IF;

       -- ������� GoodsPropertyValueId
       vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId AS GoodsPropertyValueId
                                  FROM (SELECT DISTINCT ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
                                        FROM ObjectLink AS ObjectLink_Juridical_Retail
                                                INNER JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                                     ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                                    AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                                        WHERE ObjectLink_Juridical_Retail.ChildObjectId = inRetail6Id
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId,0) <> 0
                                          AND COALESCE (ObjectLink_Juridical_GoodsProperty.ChildObjectId,0) <> 0
                                        ) AS tmpGoodsProperty
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                            AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                                       INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                                  );
       IF COALESCE (vbGoodsPropertyValueId) <> 0
       THEN
           -- ��������� ����� � <����>
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyValue_Box(), vbGoodsPropertyValueId, vbBoxId_Retail);
           -- ��������� �������� <���������� ��. � ��.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_WeightOnBox(), vbGoodsPropertyValueId, ioWeightOnBox_Retail6);
           -- ��������� �������� <���������� ��. � ��.>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyValue_CountOnBox(), vbGoodsPropertyValueId, ioCountOnBox_Retail6);
       END IF;
       ioBoxId_Retail6 := vbBoxId_Retail;
       outBoxName_Retail6 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbBoxId_Retail);
   ELSE
       ioBoxId_Retail6 := 0;
       outBoxName_Retail6 := ''::TVarChar;
   END IF;

   -- ��������� ��������� ��� �� �������
   -- ������ ����� ���
   SELECT tmp.CodeCalc_Sh, tmp.CodeCalc_Nom, tmp.CodeCalc_Ves, tmp.isCodeCalc_Diff
        , tmp.WmsCodeCalc_Sh, tmp.WmsCodeCalc_Nom, tmp.WmsCodeCalc_Ves, tmp.WmsCode

        , tmp.WeightOnBox
        , tmp.WeightGross_Sh, tmp.WeightGross_Nom, tmp.WeightGross_Ves
        , tmp.WeightAvgGross_Sh, tmp.WeightAvgGross_Nom, tmp.WeightAvgGross_Ves
        , tmp.WeightAvgNet_Sh, tmp.WeightAvgNet_Nom, tmp.WeightAvgNet_Ves
        , tmp.WeightOnBox_2, tmp.WeightGross_2, tmp.WeightAvgGross_2, tmp.WeightAvgNet_2

     INTO outCodeCalc_Sh, outCodeCalc_Nom, outCodeCalc_Ves, outisCodeCalc_Diff
        , outWmsCodeCalc_Sh, outWmsCodeCalc_Nom, outWmsCodeCalc_Ves, outWmsCode

        , outWeightOnBox
        , outWeightGross_sh   , outWeightGross_nom, outWeightGross_ves
        , outWeightAvgGross_sh, outWeightAvgGross_nom, outWeightAvgGross_ves
        , outWeightAvgNet_sh, outWeightAvgNet_nom, outWeightAvgNet_ves
        , outWeightOnBox_2, outWeightGross_2, outWeightAvgGross_2, outWeightAvgNet_2
   FROM (WITH
             tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.*
                                          , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Sh
                                          , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Nom
                                          , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Ves

                                          , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0
                                                 THEN (''||COALESCE (Object_Goods_main.ObjectCode,0)||'.'||COALESCE (Object_GoodsByGoodsKind_View.GoodsKindCode,0)||'.'||COALESCE (Object_GoodsBrand.ObjectCode,0)||'.'||CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0 THEN 1 ELSE 0 END)
                                                 ELSE NULL
                                            END  :: TVarChar AS CodeCalc_Sh
                                          , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0
                                                 THEN (''||COALESCE (Object_Goods_main.ObjectCode,0)||'.'||COALESCE (Object_GoodsByGoodsKind_View.GoodsKindCode,0)||'.'||COALESCE (Object_GoodsBrand.ObjectCode,0)||'.'||CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0 THEN 2 ELSE 0 END)
                                                 ELSE NULL
                                            END  :: TVarChar AS CodeCalc_Nom
                                          , CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0
                                                 THEN (''||COALESCE (Object_Goods_main.ObjectCode,0)||'.'||COALESCE (Object_GoodsByGoodsKind_View.GoodsKindCode,0)||'.'||COALESCE (Object_GoodsBrand.ObjectCode,0)||'.'||CASE WHEN COALESCE (ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0 THEN 3 ELSE 0 END)
                                                 ELSE NULL
                                            END  :: TVarChar AS CodeCalc_Ves
                                          --
                                          , ObjectFloat_WmsCode.ValueData AS WmsCode

                                          , CASE WHEN ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ChildObjectId <> 0
                                                 THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                                                   || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                                                -- || '.'
                                                   || '1'
                                                 ELSE ''
                                            END :: TVarChar AS WmsCodeCalc_Sh

                                          , CASE WHEN ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ChildObjectId <> 0
                                                 THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                                                    || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                                                --  || '.'
                                                    || '2'
                                                 ELSE ''
                                            END :: TVarChar AS WmsCodeCalc_Nom

                                          , CASE WHEN ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ChildObjectId  <> 0
                                                 THEN REPEAT ('', 3 - LENGTH ((ObjectFloat_WmsCode.ValueData :: Integer) :: TVarChar))
                                                    || (COALESCE (ObjectFloat_WmsCode.ValueData, 0) :: Integer) :: TVarChar
                                                 -- || '.'
                                                    || '3'
                                                 ELSE ''
                                            END :: TVarChar AS WmsCodeCalc_Ves

                                     FROM Object_GoodsByGoodsKind_View
                                          LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsMain
                                                               ON ObjectLink_GoodsByGoodsKind_GoodsMain.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                              AND ObjectLink_GoodsByGoodsKind_GoodsMain.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsMain()
                                          LEFT JOIN Object AS Object_Goods_main ON Object_Goods_main.Id = ObjectLink_GoodsByGoodsKind_GoodsMain.ChildObjectId

                                          LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsBrand
                                                               ON ObjectLink_GoodsByGoodsKind_GoodsBrand.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                              AND ObjectLink_GoodsByGoodsKind_GoodsBrand.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsBrand()
                                          LEFT JOIN Object AS Object_GoodsBrand ON Object_GoodsBrand.Id = ObjectLink_GoodsByGoodsKind_GoodsBrand.ChildObjectId

                                          LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh
                                                               ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                              AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Sh()
                                          LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom
                                                               ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                              AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Nom()
                                          LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves
                                                               ON ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                              AND ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsTypeKind_Ves()

                                          LEFT JOIN ObjectFloat AS ObjectFloat_WmsCode
                                                                ON ObjectFloat_WmsCode.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                               AND ObjectFloat_WmsCode.DescId = zc_ObjectFloat_GoodsByGoodsKind_WmsCode()
                                     WHERE Object_GoodsByGoodsKind_View.Id = ioId   --403369 --
                                     )
           , tmpCodeCalc AS (SELECT tmp.CodeCalc_Sh, tmp.CodeCalc_Nom, tmp.CodeCalc_Ves
                                  , COUNT (*) OVER (PARTITION BY tmp.CodeCalc_Sh) AS Count1
                                  , COUNT (*) OVER (PARTITION BY tmp.CodeCalc_Nom) AS Count2
                                  , COUNT (*) OVER (PARTITION BY tmp.CodeCalc_Ves) AS Count3
                             FROM tmpGoodsByGoodsKind AS tmp
                             WHERE tmp.isGoodsTypeKind_Sh  <> False
                                OR tmp.isGoodsTypeKind_Nom <> False
                                OR tmp.isGoodsTypeKind_Ves <> False
                             GROUP BY tmp.CodeCalc_Sh, tmp.CodeCalc_Nom, tmp.CodeCalc_Ves
                             )

           , tmpGoodsPropertyBox AS (SELECT ObjectLink_GoodsPropertyBox_Goods.ChildObjectId     AS GoodsId
                                          , ObjectLink_GoodsPropertyBox_GoodsKind.ChildObjectId AS GoodsKindId

                                          , ObjectLink_GoodsPropertyBox_Box.ChildObjectId  AS BoxId

                                          , ObjectFloat_WeightOnBox.ValueData    AS WeightOnBox
                                          , ObjectFloat_CountOnBox.ValueData     AS CountOnBox
                                          , ObjectFloat_Weight.ValueData         AS BoxWeight
                                      FROM Object AS Object_GoodsPropertyBox
                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_GoodsKind
                                                                ON ObjectLink_GoodsPropertyBox_GoodsKind.ObjectId = Object_GoodsPropertyBox.Id
                                                               AND ObjectLink_GoodsPropertyBox_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyBox_GoodsKind()

                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Goods
                                                                ON ObjectLink_GoodsPropertyBox_Goods.ObjectId = Object_GoodsPropertyBox.Id
                                                               AND ObjectLink_GoodsPropertyBox_Goods.DescId = zc_ObjectLink_GoodsPropertyBox_Goods()

                                           LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Box
                                                                ON ObjectLink_GoodsPropertyBox_Box.ObjectId = Object_GoodsPropertyBox.Id
                                                               AND ObjectLink_GoodsPropertyBox_Box.DescId = zc_ObjectLink_GoodsPropertyBox_Box()
                                                               AND (ObjectLink_GoodsPropertyBox_Box.ChildObjectId IN (inBoxId, inBoxId_2))   --  (1036512,1036504 ))---
                                           LEFT JOIN ObjectFloat AS ObjectFloat_WeightOnBox
                                                                 ON ObjectFloat_WeightOnBox.ObjectId = Object_GoodsPropertyBox.Id
                                                                AND ObjectFloat_WeightOnBox.DescId = zc_ObjectFloat_GoodsPropertyBox_WeightOnBox()

                                           LEFT JOIN ObjectFloat AS ObjectFloat_CountOnBox
                                                                 ON ObjectFloat_CountOnBox.ObjectId = Object_GoodsPropertyBox.Id
                                                                AND ObjectFloat_CountOnBox.DescId = zc_ObjectFloat_GoodsPropertyBox_CountOnBox()

                                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                                 ON ObjectFloat_Weight.ObjectId = ObjectLink_GoodsPropertyBox_Box.ChildObjectId
                                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Box_Weight()

                                      WHERE Object_GoodsPropertyBox.DescId = zc_Object_GoodsPropertyBox()
                                        AND Object_GoodsPropertyBox.isErased = FALSE
                     )

               --
               SELECT Object_GoodsByGoodsKind_View.CodeCalc_Sh  :: TVarChar           -- ��. - ������: ��� �� ����+���+�����+���������
                   , Object_GoodsByGoodsKind_View.CodeCalc_Nom  :: TVarChar          -- ������� - ������: ��� �� ����+���+�����+���������
                   , Object_GoodsByGoodsKind_View.CodeCalc_Ves  :: TVarChar          -- ��������� - ������: ��� �� ����+���+�����+���������

                     -- ������ ���� ��� - ������: ��� �� ����+���+�����+���������
                   , CASE WHEN Object_GoodsByGoodsKind_View.isGoodsTypeKind_Sh = FALSE AND Object_GoodsByGoodsKind_View.isGoodsTypeKind_Nom = FALSE AND Object_GoodsByGoodsKind_View.isGoodsTypeKind_Ves = FALSE THEN FALSE
                          WHEN (COALESCE (tmpCodeCalc_1.Count1, 1) + COALESCE (tmpCodeCalc_2.Count2, 1) + COALESCE (tmpCodeCalc_3.Count3, 1)) <= 3 THEN FALSE
                          ELSE TRUE
                     END  AS isCodeCalc_Diff                                         -- ������ ���� ���

                   , Object_GoodsByGoodsKind_View.WmsCode          :: Integer        -- ��� ���* ��� ��������
                   , Object_GoodsByGoodsKind_View.WmsCodeCalc_Sh   :: TVarChar       -- ��. - ��� ���* ��� ��������
                   , Object_GoodsByGoodsKind_View.WmsCodeCalc_Nom  :: TVarChar       -- ������� - ��� ���* ��� ��������
                   , Object_GoodsByGoodsKind_View.WmsCodeCalc_Ves  :: TVarChar       -- ��������� - ��� ���* ��� ��������

                      -- ���-�� ��. � ��. (E2/E3)
                    , CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                                THEN tmpGoodsPropertyBox.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                           ELSE tmpGoodsPropertyBox.WeightOnBox
                      END :: TFloat AS WeightOnBox

                      -- ��� ������ ������� ����� (E2/E3)
                    /*, (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                            ELSE tmpGoodsPropertyBox.WeightOnBox
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightGross
                      */

                      --��
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Sh.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Sh.ValueData,0)
                            ELSE tmpGoodsPropertyBox.WeightOnBox
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightGross_Sh
                     -- �������
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Nom.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Nom.ValueData,0)
                            ELSE tmpGoodsPropertyBox.WeightOnBox
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightGross_Nom
                    -- ���������
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Ves.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Ves.ValueData,0)
                            ELSE tmpGoodsPropertyBox.WeightOnBox
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightGross_Ves

                     -- ��� ������ �� �������� ���� ����� (E2/E3)
                    /*, (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND ObjectFloat_Avg_Sh.ValueData > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * ObjectFloat_Avg_Sh.ValueData
                            ELSE 0
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightAvgGross*/
                     -- ��� ������ ������� ����� "�� �������� ����" (E2/E3)
                     --��.
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Sh.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Sh.ValueData,0)
                            ELSE 0
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightAvgGross_Sh
                     -- �������
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Nom.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Nom.ValueData,0)
                            ELSE 0
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightAvgGross_Nom
                     -- ���������
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Ves.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Ves.ValueData,0)
                            ELSE 0
                       END
                     + tmpGoodsPropertyBox.BoxWeight
                      ) :: TFloat AS WeightAvgGross_Ves

                      -- ��� ����� �� �������� ���� ����� (E2/E3) - ���� ��� � WeightOnBox
                    --��
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Sh.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Sh.ValueData,0)
                            ELSE 0
                       END
                      ) :: TFloat AS WeightAvgNet_Sh
                     -- �������
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Nom.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Nom.ValueData,0)
                            ELSE 0
                       END
                      ) :: TFloat AS WeightAvgNet_Nom
                     -- ���������
                    , (CASE WHEN tmpGoodsPropertyBox.CountOnBox > 0 AND COALESCE (ObjectFloat_Avg_Ves.ValueData,0) > 0
                                 THEN tmpGoodsPropertyBox.CountOnBox * COALESCE (ObjectFloat_Avg_Ves.ValueData,0)
                            ELSE 0
                       END
                      ) :: TFloat AS WeightAvgNet_Ves

                      -- ���-�� ��. � ��. (�����)
                    , CASE WHEN tmpGoodsPropertyBox_2.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                                THEN tmpGoodsPropertyBox_2.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                           ELSE tmpGoodsPropertyBox_2.WeightOnBox
                      END :: TFloat AS WeightOnBox_2

                      -- ��� ������ ������� ����� (�����)
                    , (CASE WHEN tmpGoodsPropertyBox_2.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                                 THEN tmpGoodsPropertyBox_2.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                            ELSE tmpGoodsPropertyBox_2.WeightOnBox
                       END
                     + tmpGoodsPropertyBox_2.BoxWeight
                      ) :: TFloat AS WeightGross_2

                     -- ��� ������ �� �������� ���� ����� (�����)
                    , (CASE WHEN tmpGoodsPropertyBox_2.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                                 THEN tmpGoodsPropertyBox_2.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                            ELSE 0
                       END
                     + tmpGoodsPropertyBox_2.BoxWeight
                      ) :: TFloat AS WeightAvgGross_2

                      -- ��� ����� �� �������� ���� ����� (�����)
                    , (CASE WHEN tmpGoodsPropertyBox_2.CountOnBox > 0 AND ObjectFloat_WeightMin.ValueData > 0 AND  ObjectFloat_WeightMax.ValueData > 0
                                 THEN tmpGoodsPropertyBox_2.CountOnBox * (ObjectFloat_WeightMin.ValueData + ObjectFloat_WeightMax.ValueData) / 2
                            ELSE 0
                       END
                      ) :: TFloat AS WeightAvgNet_2

               FROM tmpGoodsByGoodsKind AS Object_GoodsByGoodsKind_View
                    LEFT JOIN ObjectFloat AS ObjectFloat_WeightMin
                                          ON ObjectFloat_WeightMin.ObjectId = Object_GoodsByGoodsKind_View.Id
                                         AND ObjectFloat_WeightMin.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightMin()

                    LEFT JOIN ObjectFloat AS ObjectFloat_WeightMax
                                          ON ObjectFloat_WeightMax.ObjectId = Object_GoodsByGoodsKind_View.Id
                                         AND ObjectFloat_WeightMax.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightMax()

                    LEFT JOIN ObjectFloat AS ObjectFloat_Avg_Sh
                                          ON ObjectFloat_Avg_Sh.ObjectId = Object_GoodsByGoodsKind_View.Id
                                         AND ObjectFloat_Avg_Sh.DescId = zc_ObjectFloat_GoodsByGoodsKind_Avg_Sh()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Avg_Nom
                                          ON ObjectFloat_Avg_Nom.ObjectId = Object_GoodsByGoodsKind_View.Id
                                         AND ObjectFloat_Avg_Nom.DescId = zc_ObjectFloat_GoodsByGoodsKind_Avg_Nom()
                    LEFT JOIN ObjectFloat AS ObjectFloat_Avg_Ves
                                          ON ObjectFloat_Avg_Ves.ObjectId = Object_GoodsByGoodsKind_View.Id
                                         AND ObjectFloat_Avg_Ves.DescId = zc_ObjectFloat_GoodsByGoodsKind_Avg_Ves()

                    LEFT JOIN (SELECT DISTINCT tmpCodeCalc.CodeCalc_Sh , tmpCodeCalc.Count1 FROM tmpCodeCalc WHERE tmpCodeCalc.CodeCalc_Sh  IS NOT NULL) AS tmpCodeCalc_1 ON tmpCodeCalc_1.CodeCalc_Sh = Object_GoodsByGoodsKind_View.CodeCalc_Sh
                    LEFT JOIN (SELECT DISTINCT tmpCodeCalc.CodeCalc_Nom, tmpCodeCalc.Count2 FROM tmpCodeCalc WHERE tmpCodeCalc.CodeCalc_Nom IS NOT NULL) AS tmpCodeCalc_2 ON tmpCodeCalc_2.CodeCalc_Nom = Object_GoodsByGoodsKind_View.CodeCalc_Nom
                    LEFT JOIN (SELECT DISTINCT tmpCodeCalc.CodeCalc_Ves, tmpCodeCalc.Count3 FROM tmpCodeCalc WHERE tmpCodeCalc.CodeCalc_Ves IS NOT NULL) AS tmpCodeCalc_3 ON tmpCodeCalc_3.CodeCalc_Ves = Object_GoodsByGoodsKind_View.CodeCalc_Ves

                    LEFT JOIN tmpGoodsPropertyBox ON tmpGoodsPropertyBox.GoodsId     = Object_GoodsByGoodsKind_View.GoodsId
                                                 AND tmpGoodsPropertyBox.GoodsKindId = Object_GoodsByGoodsKind_View.GoodsKindId
                                                 AND tmpGoodsPropertyBox.BoxId IN (zc_Box_E2(), zc_Box_E3())

                    LEFT JOIN tmpGoodsPropertyBox AS tmpGoodsPropertyBox_2
                                                  ON tmpGoodsPropertyBox_2.GoodsId     = Object_GoodsByGoodsKind_View.GoodsId
                                                 AND tmpGoodsPropertyBox_2.GoodsKindId = Object_GoodsByGoodsKind_View.GoodsKindId
                                                 AND tmpGoodsPropertyBox_2.BoxId NOT IN (zc_Box_E2(), zc_Box_E3())
               ) AS tmp;

/*   SELECT CodeCalc_Sh, CodeCalc_Nom, CodeCalc_Ves, isCodeCalc_Diff
        , WmsCodeCalc_Sh, WmsCodeCalc_Nom, WmsCodeCalc_Ves, WmsCode

        , tmp.WeightOnBox, tmp.WeightGross, tmp.WeightAvgGross, tmp.WeightAvgNet
        , tmp.WeightOnBox_2, tmp.WeightGross_2, tmp.WeightAvgGross_2, tmp.WeightAvgNet_2

     INTO outCodeCalc_Sh, outCodeCalc_Nom, outCodeCalc_Ves, outisCodeCalc_Diff
        , outWmsCodeCalc_Sh, outWmsCodeCalc_Nom, outWmsCodeCalc_Ves, outWmsCode

        , outWeightOnBox, outWeightGross, outWeightAvgGross, outWeightAvgNet
        , outWeightOnBox_2, outWeightGross_2, outWeightAvgGross_2, outWeightAvgNet_2
   FROM gpSelect_Object_GoodsByGoodsKind_VMC (0,0,0,0,0,0,inSession) AS tmp                --- �� ����� ����� ����
   WHERE tmp.Id = ioId;
   */


   outWeightMin_Sh  := (inWeightAvg_Sh  * (1-inTax_Sh/100))  :: TFloat;
   outWeightMax_Sh  := (inWeightAvg_Sh  * (1+inTax_Sh/100))  :: TFloat;
   outWeightMin_Nom := (inWeightAvg_Nom * (1-inTax_Nom/100)) :: TFloat;
   outWeightMax_Nom := (inWeightAvg_Nom * (1+inTax_Nom/100)) :: TFloat;
   outWeightMin_Ves := (inWeightAvg_Ves * (1-inTax_Ves/100)) :: TFloat;
   outWeightMax_Ves := (inWeightAvg_Ves * (1+inTax_Ves/100)) :: TFloat;


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.05.20         *
 10.04.19         *
 29.03.19         *
 22.03.19         *
 13.03.19         *
 22.06.18         *
*/

-- ����
--