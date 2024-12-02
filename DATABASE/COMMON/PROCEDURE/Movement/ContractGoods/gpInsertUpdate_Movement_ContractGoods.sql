-- Function: gpInsertUpdate_Movement_ContractGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ContractGoods (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ContractGoods(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
 INOUT ioInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ��������� / � ����� ���� ���������
    --IN inEndBeginDate        TDateTime , -- �� ����� ���� ���������
   OUT outEndBeginDate       TDateTime , -- �� ����� ���� ���������
    IN inContractId          Integer   , -- 
    IN inCurrencyId          Integer   , -- ������ 
    IN inSiteTagId           Integer   , -- ��������� ����
    IN inDiffPrice           TFloat    ,  -- ����������� % ���������� ��� ����
    IN inRoundPrice          TFloat    ,  -- ���-�� ������ ��� ���������� 
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���) 
    IN inisMultWithVAT       Boolean   , -- ���� ������� ���
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ContractGoods());
     
     -- ��������� <��������>
      SELECT tmp.ioId, tmp.ioInvNumber, tmp.outEndBeginDate
             INTO ioId, ioInvNumber, outEndBeginDate
      FROM lpInsertUpdate_Movement_ContractGoods (ioId           := ioId
                                                , ioInvNumber    := ioInvNumber
                                                , inOperDate     := inOperDate
                                                --, inEndBeginDate := inEndBeginDate
                                                , inContractId   := inContractId 
                                                , inCurrencyId   := inCurrencyId
                                                , inSiteTagId    := inSiteTagId
                                                , inDiffPrice    := inDiffPrice
                                                , inRoundPrice   := inRoundPrice 
                                                , inPriceWithVAT := inPriceWithVAT
                                                , inisMultWithVAT:= inisMultWithVAT ::Boolean
                                                , inComment      := inComment
                                                , inUserId       := vbUserId
                                                 ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.12.24         *
 15.11.24         *
 29.11.23         *
 08.11.23         *
 15.09.22         *
 05.07.21         *
*/

-- ����
-- select * from gpInsertUpdate_Movement_ContractGoods(ioId := 18775751 , ioInvNumber := '2' , ioOperDate := ('13.01.2021')::TDateTime , inOperDate_top := ('31.01.2021')::TDateTime , inPartnerId := 4126219 , inTotalCountKg := 222 , inTotalSumm := 22222 , inComment := '' ,  inSession := '5');
