-- Function: gpInsertUpdate_Object_ReceiptProdModelChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild (Integer, TVarChar, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild (Integer, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild (Integer, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild (Integer, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild (Integer, TVarChar, Integer, Integer, Integer, Integer, NUMERIC (16, 8), NUMERIC (16, 8), TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild (Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptProdModelChild(
 INOUT ioId                  Integer   ,    -- ���� ������� <>
    IN inComment             TVarChar  ,    -- �������� �������
    IN inReceiptProdModelId  Integer   ,
    IN inObjectId            Integer   ,
    IN inReceiptLevelId_top  Integer   ,
    IN inReceiptLevelId      Integer   ,
 INOUT ioValue               TVarChar    ,
 INOUT ioValue_service       TVarChar    ,
 INOUT ioForCount            TFloat    ,
   OUT outEKPrice_summ       TFloat    ,
   OUT outEKPriceWVAT_summ   TFloat    ,
-- OUT outBasis_summ         TFloat    ,
-- OUT outBasisWVAT_summ     TFloat    ,
   OUT outReceiptLevelName   TVarChar  ,
    IN ioIsCheck             Boolean  ,
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceWithVAT Boolean;

   DECLARE vbValue          NUMERIC (16, 8);
   DECLARE vbValue_service  NUMERIC (16, 8);
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptProdModelChild());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������
   vbValue        := zfConvert_StringToFloat (REPLACE (ioValue,         ',' , '.'));
   vbValue_service:= zfConvert_StringToFloat (REPLACE (ioValue_service, ',' , '.'));

   -- ������
   IF COALESCE (ioId, 0) = 0 OR vbValue <> COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_ReceiptProdModelChild_Value()), 0)
   THEN
       ioIsCheck:= TRUE;
   END IF;

   -- ������ ioValue ���� ������ 4-� ������, ����� ForCount = 1000 � � ioValue ����������� ioValue * 1000
   IF (vbValue <> vbValue :: TFloat)
   THEN
       ioForCount:= 1000;
       vbValue   := (vbValue * 1000) :: TFloat;
   ELSEIF COALESCE (ioForCount, 0) = 0
   THEN
       ioForCount:= 1;
   END IF;

   -- ������
   IF vbValue = 0 AND EXISTS (SELECT FROM Object WHERE Object.Id = inObjectId AND Object.DescId =  zc_Object_ReceiptService())
   THEN
       vbValue:= vbValue_service;
   ELSE
       -- ������
       IF vbValue = 0 THEN vbValue:= 1; END IF;
       --
       vbValue_service:= 0;
   END IF;


   -- ��������
   IF COALESCE (inReceiptProdModelId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.ReceiptProdModelId �� ����������.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ReceiptProdModelChild'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- ��������
   IF COALESCE (inObjectId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ����������.';
   END IF;


   -- ��������
   IF EXISTS (SELECT 1
              FROM ObjectLink AS ObjectLink_ReceiptProdModel
                   INNER JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id = ObjectLink_ReceiptProdModel.ObjectId
                                                                    AND Object_ReceiptProdModelChild.isErased = FALSE
                                                                    AND Object_ReceiptProdModelChild.Id <> COALESCE (ioId, 0)

                   INNER JOIN ObjectLink AS ObjectLink_Object
                                         ON ObjectLink_Object.ObjectId = ObjectLink_ReceiptProdModel.ObjectId
                                        AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
                                        AND ObjectLink_Object.ChildObjectId = inObjectId
              WHERE ObjectLink_ReceiptProdModel.ChildObjectId = inReceiptProdModelId
                AND ObjectLink_ReceiptProdModel.DescId       = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
             )
   THEN
       RAISE EXCEPTION '������.�������%<%> <%>% ��� ����������.%��/�= %'
                     , CHR (13)
                     , lfGet_Object_Article (inObjectId)
                     , lfGet_Object_ValueData (inObjectId)
                     , CHR (13)
                     , CHR (13)
                     , (SELECT tmp.Ord
                        FROM (SELECT ROW_NUMBER() OVER (ORDER BY Object_ReceiptProdModelChild.Id ASC) AS Ord
                                   , Object_ReceiptProdModelChild.Id
                                   , ObjectLink_Object.ChildObjectId AS ObjectId
                               FROM ObjectLink AS ObjectLink_ReceiptProdModel
                                    INNER JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id = ObjectLink_ReceiptProdModel.ObjectId
                                                                                     AND Object_ReceiptProdModelChild.isErased = FALSE
                                    INNER JOIN ObjectLink AS ObjectLink_Object
                                                          ON ObjectLink_Object.ObjectId = ObjectLink_ReceiptProdModel.ObjectId
                                                         AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
                               WHERE ObjectLink_ReceiptProdModel.ChildObjectId = inReceiptProdModelId
                                 AND ObjectLink_ReceiptProdModel.DescId       = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                             ) AS tmp
                        WHERE tmp.ObjectId = inObjectId
                          AND tmp.Id <> COALESCE (ioId, 0)
                        LIMIT 1
                       )
                      ;
   END IF;


   -- ��������
 /*  IF COALESCE (inObjectId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������� �� ����������.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ReceiptProdModelChild'
                                             , inUserId        := vbUserId
                                              );
   END IF;
*/
   -- ��������������
   IF COALESCE (inReceiptLevelId, 0) = 0
   THEN
       inReceiptLevelId := inReceiptLevelId_top;
   END IF;

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ReceiptProdModelChild(), 0, inComment);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptProdModelChild_Value(), ioId, vbValue);
   -- ��������� �������� <>
   IF COALESCE (ioForCount, 0) <= 0 THEN ioForCount:= 1; END IF;
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptProdModelChild_ForCount(), ioId, ioForCount);


   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel(), ioId, inReceiptProdModelId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptProdModelChild_Object(), ioId, inObjectId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel(), ioId, inReceiptLevelId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Check(), ioId, ioIsCheck);


   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- ��������� �������� <���� ����>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (����)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);
   END IF;


   -- ������
   IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId =  zc_Object_ReceiptService())
   THEN
       vbValue_service:= vbValue;
       vbValue:= 0;
   END IF;


   -- ����������
   vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

   -- ���� ������ ����� �������� ���� � ���������� �����
   SELECT (vbValue * ObjectFloat_EKPrice.ValueData) :: TFloat AS EKPrice_summ
        , (vbValue
             * CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                    * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))) :: TFloat AS EKPriceWVAT_summ

       /* , (vbValue
            * CASE WHEN vbPriceWithVAT = FALSE
                   THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                   ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
              END)  :: TFloat AS Basis_summ

        , (vbValue
            * CASE WHEN vbPriceWithVAT = FALSE
                    THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                    ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
               END) ::TFloat BasisWVAT_summ
               */
 INTO outEKPrice_summ, outEKPriceWVAT_summ     --, outBasis_summ, outBasisWVAT_summ
   FROM Object
        LEFT JOIN ObjectLink AS ObjectLink_Goods
                             ON ObjectLink_Goods.ObjectId = Object.Id
                            AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdColorPattern_Goods()

        LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                              ON ObjectFloat_EKPrice.ObjectId = COALESCE (ObjectLink_Goods.ChildObjectId, Object.Id)
                             AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

        LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                             ON ObjectLink_Goods_TaxKind.ObjectId = COALESCE (ObjectLink_Goods.ChildObjectId, Object.Id)
                            AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
        LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                              ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                             AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

        LEFT JOIN (SELECT tmp.GoodsId
                        , tmp.ValuePrice
                   FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                            , inOperDate   := CURRENT_DATE) AS tmp
                  ) AS tmpPriceBasis ON tmpPriceBasis.GoodsId = COALESCE (ObjectLink_Goods.ChildObjectId, Object.Id)
   WHERE Object.Id = inObjectId;


   outReceiptLevelName :=  (SELECT Object.ValueData FROM Object WHERE Object.Id = inReceiptLevelId);

   -- ���������� � ����
   ioValue        := CAST (vbValue         / CASE WHEN ioForCount > 0 THEN ioForCount ELSE 1 END AS TVarChar);
   ioValue_service:= CAST (vbValue_service AS TVarChar);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.12.20         * ReceiptLevel
 01.12.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ReceiptProdModelChild()
