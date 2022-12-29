-- Function: gpInsertUpdate_MI_ProductionPersonal_basic()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPersonal_basic(Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPersonal_basic(Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionPersonal_basic(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPersonalId          Integer   , -- 
    IN inMovementId_OrderClient  Integer   , -- 
   OUT outProductId          Integer   ,
   OUT outProductName        TVarChar  ,
    IN inGoodsId             Integer   , -- 
    IN inStartBegin          TDateTime ,
    IN inEndBegin            TDateTime ,
    IN inAmount              TFloat    , -- ����������
    IN inComment             TVarChar  ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId Integer; 
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionPersonal());
     vbUserId := lpGetUserBySession (inSession);

     --����� �� ������
     outProductId := (SELECT MovementLinkObject_Product.ObjectId AS ProductId
                      FROM MovementLinkObject AS MovementLinkObject_Product
                      WHERE MovementLinkObject_Product.MovementId = inMovementId_OrderClient
                       AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                     );

     -- ��������� <������� ���������>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MovementItem_ProductionPersonal (ioId
                                                        , inMovementId
                                                        , inPersonalId
                                                        , outProductId
                                                        , inGoodsId
                                                        , inStartBegin
                                                        , inEndBegin
                                                        , inAmount 
                                                        , inComment
                                                        , vbUserId
                                                        ) AS tmp;

     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     outProductName := (SELECT Object.ValueData FROM Object WHERE Object.Id = outProductId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.12.22         *
*/

-- ����
--