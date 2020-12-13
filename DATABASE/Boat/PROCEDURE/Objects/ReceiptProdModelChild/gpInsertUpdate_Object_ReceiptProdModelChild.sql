-- Function: gpInsertUpdate_Object_ReceiptProdModelChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild(Integer, TVarChar, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild(Integer, TVarChar, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptProdModelChild(
 INOUT ioId                  Integer   ,    -- ���� ������� <>
    IN inComment             TVarChar  ,    -- �������� �������
    IN inReceiptProdModelId  Integer   ,
    IN inObjectId            Integer   ,
    IN inReceiptLevelId      Integer   ,
    IN inValue               TFloat    , 
   OUT outEKPrice_summ       TFloat    ,
   OUT outEKPriceWVAT_summ   TFloat    ,
   OUT outBasis_summ         TFloat    ,
   OUT outBasisWVAT_summ     TFloat    ,
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceWithVAT Boolean;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptProdModelChild());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ReceiptProdModelChild(), 0, inComment);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptProdModelChild_Value(), ioId, inValue);
      
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel(), ioId, inReceiptProdModelId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptProdModelChild_Object(), ioId, inObjectId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel(), ioId, inReceiptLevelId);
   
   
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

   -- ����������
   vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

   -- ���� ������ ����� �������� ���� � ���������� �����
   SELECT (inValue * ObjectFloat_EKPrice.ValueData) :: TFloat AS EKPrice_summ
        , (inValue
             * CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                    * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))) :: TFloat AS EKPriceWVAT_summ
                    
        , (inValue
            * CASE WHEN vbPriceWithVAT = FALSE
                   THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                   ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
              END)  :: TFloat AS Basis_summ

        , (inValue
            * CASE WHEN vbPriceWithVAT = FALSE
                    THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                    ELSE COALESCE (tmpPriceBasis.ValuePrice, 0) 
               END) ::TFloat BasisWVAT_summ
 INTO outEKPrice_summ, outEKPriceWVAT_summ, outBasis_summ, outBasisWVAT_summ
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
