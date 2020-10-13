-- Function: gpInsertUpdate_Movement_RelatedProduct()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_RelatedProduct (Integer, TVarChar, TDateTime, Integer, TFloat, TVarChar, TBlob, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_RelatedProduct(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inRetailID              Integer    , -- �������� ����
    IN inPriceMin              Tfloat     , -- �� ���� ������
    IN inComment               TVarChar   , -- ����������
    IN inMessage               TBlob      , -- ���������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := inSession;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_RelatedProduct (ioId            := ioId
                                                  , inInvNumber     := inInvNumber
                                                  , inOperDate      := inOperDate
                                                  , inRetailID      := inRetailID
                                                  , inPriceMin      := inPriceMin
                                                  , inComment       := inComment
                                                  , inMessage       := inMessage
                                                  , inUserId        := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ������ �.�.
 13.10.20                                                       *
*/