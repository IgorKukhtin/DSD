-- Function: gpSelect_Object_GoodsByGoodsKind_VMC(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind_lineVMC (Integer,Integer,Integer,Integer,Integer,Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsByGoodsKind_lineVMC (Integer,Integer,Integer,Integer,Integer,Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsByGoodsKind_lineVMC(
    IN inRetail1Id       Integer,
    IN inRetail2Id       Integer,
    IN inRetail3Id       Integer,
    IN inRetail4Id       Integer,
    IN inRetail5Id       Integer,
    IN inRetail6Id       Integer,
    IN inisShowAll       Boolean,
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, Code Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsGroupAnalystName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , GoodsPlatformName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , Weight TFloat
             , WeightPackage TFloat, WeightPackageSticker TFloat
             , WeightTotal TFloat, ChangePercentAmount TFloat
             , WeightAvg TFloat
             , Tax TFloat
             , WeightMin TFloat, WeightMax TFloat
             
             , Height TFloat, Length TFloat, Width TFloat
             , NormInDays TFloat
             , isOrder Boolean, isScaleCeh Boolean, isNotMobile Boolean
             , GoodsSubId Integer, GoodsSubCode Integer, GoodsSubName TVarChar, MeasureSubName TVarChar
             , GoodsKindSubId Integer, GoodsKindSubName TVarChar
             , GoodsPackId Integer, GoodsPackCode Integer, GoodsPackName TVarChar, MeasurePackName TVarChar
             , GoodsKindPackId Integer, GoodsKindPackName TVarChar
             , GoodsId_Sh Integer, GoodsCode_Sh Integer, GoodsName_Sh TVarChar
             , GoodsKindId_Sh Integer, GoodsKindName_Sh TVarChar
             , ReceiptId Integer, ReceiptCode TVarChar, ReceiptName TVarChar
             , GoodsCode_basis Integer, GoodsName_basis TVarChar
             , GoodsCode_main Integer, GoodsName_main TVarChar
             , GoodsBrandName TVarChar
             , isCheck_basis Boolean, isCheck_main Boolean
             , GoodsTypeKindId Integer, GoodsTypeKindName TVarChar
             , isGoodsTypeKind_Sh Boolean, isGoodsTypeKind_Nom Boolean, isGoodsTypeKind_Ves Boolean

           --, CodeCalc TVarChar      -- ��� ���
           --, isCodeCalc_Diff Boolean   -- ������ ���� ���

             , WmsCellNum        Integer     -- � ������ �� ������ ���
             , WmsCode           Integer     -- ����� ��� ���*

             --
             , GoodsPropertyBoxId Integer
             , BoxId Integer, BoxCode Integer, BoxName TVarChar -- ���� (E2/E3)
             , WeightOnBox TFloat                               -- ���-�� ��. � ��. (E2/E3)
             , CountOnBox TFloat                                -- ���-�� ��. � ��. (E2/E3)
             , BoxVolume TFloat
             , BoxWeight TFloat
             , BoxHeight TFloat
             , BoxLength TFloat
             , BoxWidth TFloat
             , WeightGross TFloat                               -- ��� ������ ������� ����� "�� ???" (E2/E3)

             , WeightAvgGross TFloat                            -- ��� ������ ������� ����� "�� �������� ����" (E2/E3)
             , WeightMinGross TFloat                            -- ��� ������ ������� ����� "�� ��� ����" (E2/E3)
             , WeightMaxGross TFloat                            -- ��� ������ ������� ����� "�� ���� ����" (E2/E3)

             , WeightAvgNet TFloat                              -- ��� ����� ������� ����� "�� �������� ����" (E2/E3)
             , WeightMinNet TFloat                              -- ��� ����� ������� ����� "�� ��� ����" (E2/E3)
             , WeightMaxNet TFloat                              -- ��� ����� ������� ����� "�� ���� ����" (E2/E3)

             , GoodsPropertyBoxId_2 Integer
             , BoxId_2 Integer, BoxCode_2 Integer, BoxName_2 TVarChar
             , WeightOnBox_2 TFloat, CountOnBox_2 TFloat
             , BoxVolume_2 TFloat, BoxWeight_2 TFloat
             , BoxHeight_2 TFloat, BoxLength_2 TFloat, BoxWidth_2 TFloat
             , WeightGross_2 TFloat                             -- ��� ������ ������� ����� "�� ???" (�����)
             , WeightAvgGross_2 TFloat                          -- ��� ������ ������� ����� "�� �������� ����" (�����)
             , WeightAvgNet_2 TFloat                            -- ��� ����� ������� ����� "�� �������� ����" (�����)

             , BoxId_Retail1 Integer, BoxName_Retail1 TVarChar  -- ���� ��� ���� 1
             , BoxId_Retail2 Integer, BoxName_Retail2 TVarChar  -- ���� ��� ���� 2
             , BoxId_Retail3 Integer, BoxName_Retail3 TVarChar  -- ���� ��� ���� 3
             , BoxId_Retail4 Integer, BoxName_Retail4 TVarChar  -- ���� ��� ���� 4
             , BoxId_Retail5 Integer, BoxName_Retail5 TVarChar  -- ���� ��� ���� 5
             , BoxId_Retail6 Integer, BoxName_Retail6 TVarChar  -- ���� ��� ���� 6
             , WeightOnBox_Retail1 TFloat                       -- ���������� ��. � ��. ��� ���� 1
             , WeightOnBox_Retail2 TFloat                       -- ���������� ��. � ��. ��� ���� 2
             , WeightOnBox_Retail3 TFloat                       -- ���������� ��. � ��. ��� ���� 3
             , WeightOnBox_Retail4 TFloat                       -- ���������� ��. � ��. ��� ���� 4
             , WeightOnBox_Retail5 TFloat                       -- ���������� ��. � ��. ��� ���� 5
             , WeightOnBox_Retail6 TFloat                       -- ���������� ��. � ��. ��� ���� 6
             , CountOnBox_Retail1 TFloat                        -- ���������� ��. � ��. ��� ���� 1
             , CountOnBox_Retail2 TFloat                        -- ���������� ��. � ��. ��� ���� 2
             , CountOnBox_Retail3 TFloat                        -- ���������� ��. � ��. ��� ���� 3
             , CountOnBox_Retail4 TFloat                        -- ���������� ��. � ��. ��� ���� 4
             , CountOnBox_Retail5 TFloat                        -- ���������� ��. � ��. ��� ���� 5
             , CountOnBox_Retail6 TFloat                        -- ���������� ��. � ��. ��� ���� 6

             , WmsNameCalc TVarChar
             , sku_code    Integer
              )
AS
$BODY$
   DECLARE vbName_Sh  TVarChar;
   DECLARE vbName_Nom TVarChar;
   DECLARE vbName_Ves TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());

     -- �������
     vbName_Sh := (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GoodsTypeKind_Sh());
     -- �����������
     vbName_Nom:= (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GoodsTypeKind_Nom());
     -- �������
     vbName_Ves:= (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_Enum_GoodsTypeKind_Ves());


     RETURN QUERY
     WITH
     tmpGoodsByGoodsKind AS (SELECT *
                                  , zfCalc_Text_replace (zfCalc_Text_replace (tmp.GoodsName, CHR(39), '`'), '"', '`') AS GoodsName_repl
                             FROM gpSelect_Object_GoodsByGoodsKind_VMC (inRetail1Id, inRetail2Id , inRetail3Id, inRetail4Id, inRetail5Id, inRetail6Id, inSession) AS tmp
                            )
     , tmpGoodsByGoodsKind_line AS (-- �������
                                  SELECT *
                                       , (tmp.GoodsName_repl || ' ' || tmp.GoodsKindName || ' ' || vbName_Sh) :: TVarChar AS WmsNameCalc
                                       , tmp.WmsCodeCalc_Sh   ::Integer   AS sku_code
                                     --, tmp.CodeCalc_Sh                  AS CodeCalc
                                       , zc_Enum_GoodsTypeKind_Sh()       AS GoodsTypeKindId

                                       , tmp.WeightAvg_Sh                 AS WeightAvg
                                       , tmp.Tax_Sh                       AS Tax
                                       , tmp.WeightMin_Sh                 AS WeightMin
                                       , tmp.WeightMax_Sh                 AS WeightMax
                                       , tmp.WeightGross_Sh               AS WeightGross
                                       , tmp.WeightAvgGross_Sh            AS WeightAvgGross
                                       , tmp.WeightMinGross_Sh            AS WeightMinGross
                                       , tmp.WeightMaxGross_Sh            AS WeightMaxGross
                                       , tmp.WeightAvgNet_Sh              AS WeightAvgNet
                                       , tmp.WeightMinNet_Sh              AS WeightMinNet
                                       , tmp.WeightMaxNet_Sh              AS WeightMaxNet
                                       , tmp.WeightOnBox_Sh               AS WeightOnBox_real
            
                                  FROM tmpGoodsByGoodsKind AS tmp
                                  WHERE tmp.isGoodsTypeKind_Sh  = TRUE
                                 UNION ALL
                                  -- �����������
                                  SELECT *
                                       , (tmp.GoodsName_repl || ' ' || tmp.GoodsKindName || ' ' || vbName_Nom) :: TVarChar AS WmsNameCalc
                                       , tmp.WmsCodeCalc_Nom  ::Integer   AS sku_code
                                     --, tmp.CodeCalc_Nom                 AS CodeCalc
                                       , zc_Enum_GoodsTypeKind_Nom()      AS GoodsTypeKindId

                                       , tmp.WeightAvg_Nom                AS WeightAvg
                                       , tmp.Tax_Nom                      AS Tax
                                       , tmp.WeightMin_Nom                AS WeightMin
                                       , tmp.WeightMax_Nom                AS WeightMax
                                       , tmp.WeightGross_Nom              AS WeightGross
                                       , tmp.WeightAvgGross_Nom           AS WeightAvgGross
                                       , tmp.WeightMinGross_Nom           AS WeightMinGross
                                       , tmp.WeightMaxGross_Nom           AS WeightMaxGross
                                       , tmp.WeightAvgNet_Nom             AS WeightAvgNet
                                       , tmp.WeightMinNet_Nom             AS WeightMinNet
                                       , tmp.WeightMaxNet_Nom             AS WeightMaxNet
                                       , tmp.WeightOnBox_Nom              AS WeightOnBox_real
                                       
                                  FROM tmpGoodsByGoodsKind AS tmp
                                  WHERE tmp.isGoodsTypeKind_Nom  = TRUE
                                 UNION ALL
                                  -- �������
                                  SELECT *
                                       , (tmp.GoodsName_repl || ' ' || tmp.GoodsKindName || ' ' || vbName_Ves) :: TVarChar AS WmsNameCalc
                                       , tmp.WmsCodeCalc_Ves  ::Integer   AS sku_code
                                     --, tmp.CodeCalc_Ves                 AS CodeCalc
                                       , zc_Enum_GoodsTypeKind_Ves()      AS GoodsTypeKindId

                                       , tmp.WeightAvg_Ves                AS WeightAvg
                                       , tmp.Tax_Ves                      AS Tax
                                       , tmp.WeightMin_Ves                AS WeightMin
                                       , tmp.WeightMax_Ves                AS WeightMax
                                       , tmp.WeightGross_Ves              AS WeightGross
                                       , tmp.WeightAvgGross_Ves           AS WeightAvgGross
                                       , tmp.WeightMinGross_Ves           AS WeightMinGross
                                       , tmp.WeightMaxGross_Ves           AS WeightMaxGross
                                       , tmp.WeightAvgNet_Ves             AS WeightAvgNet
                                       , tmp.WeightMinNet_Ves             AS WeightMinNet
                                       , tmp.WeightMaxNet_Ves             AS WeightMaxNet
                                       , tmp.WeightOnBox_Ves              AS WeightOnBox_real
                                       
                                  FROM tmpGoodsByGoodsKind AS tmp
                                  WHERE tmp.isGoodsTypeKind_Ves  = TRUE
                                 UNION ALL
                                  -- ��������� ������ (��� �������� ���)
                                  SELECT *
                                       , '' :: TVarChar AS WmsNameCalc
                                       , 0  :: Integer  AS sku_code
                                     --, '' :: TVarChar AS CodeCalc
                                       , 0              AS GoodsTypeKindId

                                       , 0  :: TFloat   AS WeightAvg
                                       , 0  :: TFloat   AS Tax
                                       , 0  :: TFloat   AS WeightMin
                                       , 0  :: TFloat   AS WeightMax
                                       , 0  :: TFloat   AS WeightGross
                                       , 0  :: TFloat   AS WeightAvgGross
                                       , 0  :: TFloat   AS WeightMinGross
                                       , 0  :: TFloat   AS WeightMaxGross
                                       , 0  :: TFloat   AS WeightAvgNet
                                       , 0  :: TFloat   AS WeightMinNet
                                       , 0  :: TFloat   AS WeightMaxNet
                                       , 0  :: TFloat   AS WeightOnBox_real
                                  FROM tmpGoodsByGoodsKind
                                  WHERE (tmpGoodsByGoodsKind.isGoodsTypeKind_Sh <> TRUE
                                    AND tmpGoodsByGoodsKind.isGoodsTypeKind_Ves <> TRUE
                                    AND tmpGoodsByGoodsKind.isGoodsTypeKind_Nom <> TRUE)
                                    AND inisShowAll = TRUE
                                 )

       -- ���������
       SELECT
             tmpGoodsByGoodsKind.Id
           , tmpGoodsByGoodsKind.GoodsId
           , tmpGoodsByGoodsKind.Code
           , tmpGoodsByGoodsKind.GoodsName
           , tmpGoodsByGoodsKind.GoodsKindId
           , tmpGoodsByGoodsKind.GoodsKindCode
           , tmpGoodsByGoodsKind.GoodsKindName

           , tmpGoodsByGoodsKind.GoodsGroupId
           , tmpGoodsByGoodsKind.GoodsGroupName
           , tmpGoodsByGoodsKind.GoodsGroupNameFull

           , tmpGoodsByGoodsKind.GoodsGroupAnalystName
           , tmpGoodsByGoodsKind.TradeMarkName
           , tmpGoodsByGoodsKind.GoodsTagName
           , tmpGoodsByGoodsKind.GoodsPlatformName

           , tmpGoodsByGoodsKind.InfoMoneyCode
           , tmpGoodsByGoodsKind.InfoMoneyGroupName
           , tmpGoodsByGoodsKind.InfoMoneyDestinationName
           , tmpGoodsByGoodsKind.InfoMoneyName

           , tmpGoodsByGoodsKind.MeasureId
           , tmpGoodsByGoodsKind.MeasureName

           , tmpGoodsByGoodsKind.Weight

           , tmpGoodsByGoodsKind.WeightPackage
           , tmpGoodsByGoodsKind.WeightPackageSticker
           , tmpGoodsByGoodsKind.WeightTotal
           , tmpGoodsByGoodsKind.ChangePercentAmount

           , tmpGoodsByGoodsKind.WeightAvg
           , tmpGoodsByGoodsKind.Tax

           , tmpGoodsByGoodsKind.WeightMin
           , tmpGoodsByGoodsKind.WeightMax
           
           , tmpGoodsByGoodsKind.Height
           , tmpGoodsByGoodsKind.Length
           , tmpGoodsByGoodsKind.Width
           , tmpGoodsByGoodsKind.NormInDays

           , tmpGoodsByGoodsKind.isOrder
           , tmpGoodsByGoodsKind.isScaleCeh
           , tmpGoodsByGoodsKind.isNotMobile

           , tmpGoodsByGoodsKind.GoodsSubId
           , tmpGoodsByGoodsKind.GoodsSubCode
           , tmpGoodsByGoodsKind.GoodsSubName
           , tmpGoodsByGoodsKind.MeasureSubName
           , tmpGoodsByGoodsKind.GoodsKindSubId
           , tmpGoodsByGoodsKind.GoodsKindSubName

           , tmpGoodsByGoodsKind.GoodsPackId
           , tmpGoodsByGoodsKind.GoodsPackCode
           , tmpGoodsByGoodsKind.GoodsPackName
           , tmpGoodsByGoodsKind.MeasurePackName
           , tmpGoodsByGoodsKind.GoodsKindPackId
           , tmpGoodsByGoodsKind.GoodsKindPackName

           , tmpGoodsByGoodsKind.GoodsId_Sh
           , CASE WHEN tmpGoodsByGoodsKind.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() THEN tmpGoodsByGoodsKind.GoodsCode_Sh ELSE 0 END :: Integer AS GoodsCode_Sh
           , CASE WHEN tmpGoodsByGoodsKind.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() THEN tmpGoodsByGoodsKind.GoodsName_Sh ELSE '' END :: TVarChar AS GoodsName_Sh
           , tmpGoodsByGoodsKind.GoodsKindId_Sh
           , CASE WHEN tmpGoodsByGoodsKind.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh() THEN tmpGoodsByGoodsKind.GoodsKindName_Sh ELSE '' END :: TVarChar AS GoodsKindName_Sh

           , tmpGoodsByGoodsKind.ReceiptId
           , tmpGoodsByGoodsKind.ReceiptCode
           , tmpGoodsByGoodsKind.ReceiptName

           , tmpGoodsByGoodsKind.GoodsCode_basis
           , tmpGoodsByGoodsKind.GoodsName_basis
           , tmpGoodsByGoodsKind.GoodsCode_main
           , tmpGoodsByGoodsKind.GoodsName_main
           , tmpGoodsByGoodsKind.GoodsBrandName

           , tmpGoodsByGoodsKind.isCheck_basis
           , tmpGoodsByGoodsKind.isCheck_main

           , tmpGoodsByGoodsKind.GoodsTypeKindId
           , Object_GoodsTypeKind.ValueData AS GoodsTypeKindName
           , tmpGoodsByGoodsKind.isGoodsTypeKind_Sh
           , tmpGoodsByGoodsKind.isGoodsTypeKind_Nom
           , tmpGoodsByGoodsKind.isGoodsTypeKind_Ves

         --, COALESCE (tmpGoodsByGoodsKind_line_sh.CodeCalc, tmpGoodsByGoodsKind.CodeCalc) :: TVarChar AS CodeCalc -- ������: ��� �� ����+���+�����+���������
             -- ������ ���� ��� - ������: ��� �� ����+���+�����+���������
         --, tmpGoodsByGoodsKind.isCodeCalc_Diff                                         -- ������ ���� ���

           , COALESCE (tmpGoodsByGoodsKind_line_sh.WmsCellNum, tmpGoodsByGoodsKind.WmsCellNum)  :: Integer AS WmsCellNum    -- 
           , COALESCE (tmpGoodsByGoodsKind_line_sh.WmsCode, tmpGoodsByGoodsKind.WmsCode)        :: Integer AS WmsCode       -- ��� ���* ��� ��������
            -- ���� (E2/E3)
            , tmpGoodsByGoodsKind.GoodsPropertyBoxId
            , tmpGoodsByGoodsKind.BoxId
            , tmpGoodsByGoodsKind.BoxCode
            , tmpGoodsByGoodsKind.BoxName

              -- ���-�� ��. � ��. (E2/E3) - ���� ��� � WeightAvgNet
            , tmpGoodsByGoodsKind.WeightOnBox_real AS WeightOnBox
              -- ���-�� ��. � ��. (E2/E3)
            , tmpGoodsByGoodsKind.CountOnBox

            , tmpGoodsByGoodsKind.BoxVolume
            , tmpGoodsByGoodsKind.BoxWeight
            , tmpGoodsByGoodsKind.BoxHeight
            , tmpGoodsByGoodsKind.BoxLength
            , tmpGoodsByGoodsKind.BoxWidth

            -- ��� ������ ������� ����� "??? �� �������� ����" (E2/E3)
            , tmpGoodsByGoodsKind.WeightGross
            -- ��� ������ ������� ����� "�� �������� ����" (E2/E3)
            , tmpGoodsByGoodsKind.WeightAvgGross
            -- ��� ������ ������� ����� "�� ��� ����" (E2/E3)
            , tmpGoodsByGoodsKind.WeightMinGross
            -- ��� ������ ������� ����� "�� ���� ����" (E2/E3)
            , tmpGoodsByGoodsKind.WeightMaxGross


              -- ��� ����� �� �������� ���� ����� (E2/E3) - ���� ��� � WeightOnBox
            , tmpGoodsByGoodsKind.WeightAvgNet
            
            -- ��� ����� ������� ����� "�� ��� ����" (E2/E3)
            , tmpGoodsByGoodsKind.WeightMinNet
            -- ��� ����� ������� ����� "�� ���� ����" (E2/E3)
            , tmpGoodsByGoodsKind.WeightMaxNet

            -- ���� (�����)
            , tmpGoodsByGoodsKind.GoodsPropertyBoxId_2
            , tmpGoodsByGoodsKind.BoxId_2
            , tmpGoodsByGoodsKind.BoxCode_2
            , tmpGoodsByGoodsKind.BoxName_2

              -- ���-�� ��. � ��. (�����)
            , tmpGoodsByGoodsKind.WeightOnBox_2
              -- ���-�� ��. � ��. (�����)
            , tmpGoodsByGoodsKind.CountOnBox_2

            , tmpGoodsByGoodsKind.BoxVolume_2
            , tmpGoodsByGoodsKind.BoxWeight_2
            , tmpGoodsByGoodsKind.BoxHeight_2
            , tmpGoodsByGoodsKind.BoxLength_2
            , tmpGoodsByGoodsKind.BoxWidth_2

              -- ��� ������ ������� ����� "�� ???" (�����)
            , tmpGoodsByGoodsKind.WeightGross_2

             -- ��� ������ ������� ����� "�� �������� ����" (�����)
            , tmpGoodsByGoodsKind.WeightAvgGross_2

              -- ��� ����� ������� ����� "�� �������� ����" (�����)
            , tmpGoodsByGoodsKind.WeightAvgNet_2

              -- ����� �������� ���� 1-6
            , tmpGoodsByGoodsKind.BoxId_Retail1, tmpGoodsByGoodsKind.BoxName_Retail1
            , tmpGoodsByGoodsKind.BoxId_Retail2, tmpGoodsByGoodsKind.BoxName_Retail2
            , tmpGoodsByGoodsKind.BoxId_Retail3, tmpGoodsByGoodsKind.BoxName_Retail3
            , tmpGoodsByGoodsKind.BoxId_Retail4, tmpGoodsByGoodsKind.BoxName_Retail4
            , tmpGoodsByGoodsKind.BoxId_Retail5, tmpGoodsByGoodsKind.BoxName_Retail5
            , tmpGoodsByGoodsKind.BoxId_Retail6, tmpGoodsByGoodsKind.BoxName_Retail6
            -- ���������� ��. � ��. ��� ����� 1-6
            , tmpGoodsByGoodsKind.WeightOnBox_Retail1
            , tmpGoodsByGoodsKind.WeightOnBox_Retail2
            , tmpGoodsByGoodsKind.WeightOnBox_Retail3
            , tmpGoodsByGoodsKind.WeightOnBox_Retail4
            , tmpGoodsByGoodsKind.WeightOnBox_Retail5
            , tmpGoodsByGoodsKind.WeightOnBox_Retail6
            -- ���������� ��. � ��. ��� ����� 1-6
            , tmpGoodsByGoodsKind.CountOnBox_Retail1
            , tmpGoodsByGoodsKind.CountOnBox_Retail2
            , tmpGoodsByGoodsKind.CountOnBox_Retail3
            , tmpGoodsByGoodsKind.CountOnBox_Retail4
            , tmpGoodsByGoodsKind.CountOnBox_Retail5
            , tmpGoodsByGoodsKind.CountOnBox_Retail6

            , COALESCE (tmpGoodsByGoodsKind_line_sh.WmsNameCalc, tmpGoodsByGoodsKind.WmsNameCalc) :: TVarChar AS WmsNameCalc
            , COALESCE (tmpGoodsByGoodsKind_line_sh.sku_code, tmpGoodsByGoodsKind.sku_code)       :: Integer  AS sku_code

        FROM tmpGoodsByGoodsKind_line AS tmpGoodsByGoodsKind
             LEFT JOIN Object AS Object_GoodsTypeKind ON Object_GoodsTypeKind.Id = tmpGoodsByGoodsKind.GoodsTypeKindId  
             LEFT JOIN tmpGoodsByGoodsKind_line AS tmpGoodsByGoodsKind_line_sh
                                                ON tmpGoodsByGoodsKind_line_sh.GoodsId         = tmpGoodsByGoodsKind.GoodsId_sh
                                               AND tmpGoodsByGoodsKind_line_sh.GoodsKindId     = tmpGoodsByGoodsKind.GoodsKindId_sh
                                               AND tmpGoodsByGoodsKind_line_sh.GoodsTypeKindId = zc_Enum_GoodsTypeKind_Sh()
                                               AND tmpGoodsByGoodsKind.GoodsTypeKindId         = zc_Enum_GoodsTypeKind_Sh()
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 10.03.20        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind_lineVMC (0,0,0,0,0,0,FALSE,zfCalc_UserAdmin())--  limit 10  where sku_code = 1852
