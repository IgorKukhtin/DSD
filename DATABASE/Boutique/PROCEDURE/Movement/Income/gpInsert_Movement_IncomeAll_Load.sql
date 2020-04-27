-- Function: gpInsert_Movement_IncomeAll_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MIEdit_IncomeLoad (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar ,TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_IncomeAll_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_IncomeAll_Load(
    IN inOperDate              TDateTime ,
    IN inObjectCode            Integer   , -- ��� ������ / ��������
    IN inPeriodName            TVarChar  , -- �����
    IN inBrandName             TVarChar  , -- �������� �����
    IN inGoodsGroupName        TVarChar  , -- ������ ������
    IN inLabelName             TVarChar  , -- �������� ��� �������
    IN inCompositionName       TVarChar  , -- ������ ������
    IN inGoodsInfoName         TVarChar  , -- �������� ������
    IN inOperPrice             TFloat    , -- �� ����
    IN inOperPriceList         TFloat    , -- ���� �������
    IN inAmount                TFloat    , -- ���-��
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId             Integer;
   DECLARE vbCurrencyId         Integer;
   DECLARE vbPartnerId          Integer;
   DECLARE vbUnitId             Integer;
   DECLARE vbBrandId            Integer;
   DECLARE vbPeriodId           Integer;
   DECLARE vbMovementId         Integer;
   DECLARE vbGoodsGroupParentId Integer;
   DECLARE vbGoodsGroupId       Integer;
   DECLARE vbGoodsGroupId_arc   Integer;
   DECLARE vbCurrencyValue      TFloat;
   DECLARE vbParValue           TFloat;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService_Child());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������ ����� ������ ��� ������� <> 0
     IF COALESCE (inAmount, 0) = 0
     THEN
         -- !!!�����!!!
         RETURN;
     END IF;


     -- �������������
     vbUnitId := (SELECT Object.Id
                  FROM Object
                  WHERE Object.DescId = zc_Object_Unit()
                     AND TRIM (Object.ValueData) ILIKE TRIM ('%������� PODIUM%') -- ������� PODIUM ���� ��� ��������� � ����� ��������
                  );
     -- ������
     vbCurrencyId := zc_Currency_EUR();
     IF COALESCE (vbCurrencyId,0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������� <������> <%>.', inCurrencyName;
     END IF;


     -- �������� �����
     vbBrandId := (SELECT Object.Id
                   FROM Object
                   WHERE Object.DescId = zc_Object_Brand()
                      AND TRIM (Object.ValueData) ILIKE TRIM (inBrandName)
                   );
     -- ���� �� �����
     IF COALESCE (vbBrandId, 0) = 0
     THEN
         -- ��������
         vbBrandId := (SELECT tmp.ioId
                       FROM gpInsertUpdate_Object_Brand (ioId             := 0
                                                       , ioCode           := 0
                                                       , inName           := TRIM (inBrandName)
                                                       , inCountryBrandId := 242 -- ������
                                                       , inSession        := inSession
                                                        ) AS tmp);
     END IF;

     -- �����
     vbPeriodId := (SELECT Object.Id
                    FROM Object
                    WHERE Object.DescId = zc_Object_Period()
                      AND TRIM (Object.ValueData) ILIKE ('%' || TRIM (LEFT (inPeriodName, LENGTH (inPeriodName) - 4)) ||'%')
                    );
     -- ���� �� �����
     IF COALESCE (vbPeriodId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������� <�����> <%>.', inPeriodName;
     END IF;
     -- ���� �� �����
     -- IF COALESCE (vbPeriodId, 0) = 0
     -- THEN
         -- ��������
     --     vbPeriodId := (SELECT tmp.ioId
     --                    FROM gpInsertUpdate_Object_Period (ioId          := 0
     --                                                     , ioCode        := 0
     --                                                     , inName        := TRIM (LEFT (inPeriodName, LENGTH (inPeriodName) - 4))
     --                                                     , inSession     := inSession
     --                                                      ) AS tmp);
     -- END IF;


     -- ����� ����������
     vbPartnerId := (SELECT Object.Id
                     FROM Object
                          LEFT JOIN Object AS Object_Period ON Object_Period.Id = vbPeriodId
                     WHERE Object.DescId = zc_Object_Partner()
                        AND TRIM (Object.ValueData) ILIKE (TRIM (inBrandName)
                                                  ||'-' || TRIM (Object_Period.ValueData)
                                                  ||'-' || TRIM (RIGHT (inPeriodName, 4))
                                                          )
                    );
     -- ���� �� �����
     IF COALESCE (vbPartnerId,0) = 0
     THEN
         -- �������� ����������
         vbPartnerId:= (SELECT tmp.ioId FROM gpInsertUpdate_Object_Partner (ioId            := 0
                                                                          , ioCode          := 0
                                                                          , inBrandId       := vbBrandId
                                                                          , inFabrikaId     := 0
                                                                          , inPeriodId      := vbPeriodId
                                                                          , inPeriodYear    := TRIM (RIGHT (inPeriodName, 4)) ::TFloat
                                                                          , inSession       := inSession
                                                                           ) AS tmp);
     END IF;


     -- ����� �������� �� ����� ����, ���������, �������
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MLO_From
                                                         ON MLO_From.MovementId = Movement.Id
                                                        AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                        AND MLO_From.ObjectId   = vbPartnerId
                           INNER JOIN MovementLinkObject AS MLO_To
                                                         ON MLO_To.MovementId = Movement.Id
                                                        AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                        AND MLO_To.ObjectId   = vbUnitId

                         --INNER JOIN MovementLinkObject AS MLO_CurrencyDocument
                         --                              ON MLO_CurrencyDocument.MovementId = Movement.Id
                         --                             AND MLO_CurrencyDocument.DescId     = zc_MovementLinkObject_CurrencyDocument()
                         --                             AND MLO_CurrencyDocument.ObjectId   = vbCurrencyId
                      WHERE Movement.DescId   = zc_Movement_Income()
                        AND Movement.OperDate = inOperDate
                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                     );


     IF COALESCE (vbMovementId, 0) = 0
     THEN
         -- ���� �� ������� ������
         IF vbCurrencyId <> zc_Currency_Basis()
         THEN
             -- ���������� ���� �� ���� ���������
             SELECT COALESCE (tmp.Amount, 1), COALESCE (tmp.ParValue,0)
                    INTO vbCurrencyValue, vbParValue
             FROM lfSelect_Movement_Currency_byDate (inOperDate      := inOperDate
                                                   , inCurrencyFromId:= zc_Currency_Basis()
                                                   , inCurrencyToId  := vbCurrencyId
                                                    ) AS tmp;
         ELSE
             -- ���� �� �����
             vbCurrencyValue:= 0;
             vbParValue     := 0;
         END IF;

         -- ��������� <��������>
         vbMovementId := lpInsertUpdate_Movement_Income (ioId                := 0
                                                       , inInvNumber         := CAST (NEXTVAL ('Movement_Income_seq') AS TVarChar)
                                                       , inOperDate          := inOperDate
                                                       , inFromId            := vbPartnerId
                                                       , inToId              := vbUnitId
                                                       , inCurrencyDocumentId:= vbCurrencyId
                                                       , inCurrencyValue     := vbCurrencyValue
                                                       , inParValue          := vbParValue
                                                       , inComment           := '��������' ::TVarChar
                                                       , inUserId            := vbUserId
                                                        );
     END IF;



     -- ������ ������ - �����
     vbGoodsGroupId_arc:= (SELECT Object.Id
                           FROM Object
                           WHERE Object.DescId    = zc_Object_GoodsGroup()
                             AND Object.ValueData ILIKE '�����'
                          );
     IF COALESCE (vbGoodsGroupId_arc, 0) = 0
     THEN
         -- ��������
         vbGoodsGroupId_arc := (SELECT tmp.ioId FROM gpInsertUpdate_Object_GoodsGroup (ioId          := 0
                                                                                     , ioCode        := 0
                                                                                     , inName        := '�����'
                                                                                     , inParentId    := 0
                                                                                     , inInfoMoneyId := 0
                                                                                     , inSession     := inSession
                                                                                      ) AS tmp);
     END IF;

     -- ������ ������
     vbGoodsGroupId:= (SELECT Object.Id
                       FROM Object
                            INNER JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                                  ON ObjectLink_GoodsGroup_Parent.ObjectId      = Object.Id
                                                 AND ObjectLink_GoodsGroup_Parent.ChildObjectId = vbGoodsGroupId_arc
                                                 AND ObjectLink_GoodsGroup_Parent.DescId        = zc_ObjectLink_GoodsGroup_Parent()
                       WHERE Object.DescId    = zc_Object_GoodsGroup()
                         AND Object.ValueData ILIKE TRIM (inGoodsGroupName)
                      );
     IF COALESCE (vbGoodsGroupId, 0) = 0
     THEN
         -- ��������
         vbGoodsGroupId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_GoodsGroup (ioId          := 0
                                                                                 , ioCode        := 0
                                                                                 , inName        := TRIM (inGoodsGroupName)
                                                                                 , inParentId    := vbGoodsGroupId_arc
                                                                                 , inInfoMoneyId := 0
                                                                                 , inSession     := inSession
                                                                                   ) AS tmp);
     END IF;

     -- �������
     PERFORM gpInsertUpdate_MIEdit_Income (ioId                 :=   0  -- ���� ������� <������� ���������>
                                         , inMovementId         :=   vbMovementId
                                         , inGoodsGroupId       :=   vbGoodsGroupId
                                         , inMeasureId          :=   (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Measure() AND Object.ValueData ILIKE '%��%')
                                         , inJuridicalId        :=   0         -- ��.����(����)
                                         , ioGoodsCode          :=   inObjectCode  ::Integer      -- ��� ������ --NEXTVAL ('Object_Goods_seq')   ::Integer      -- ��� ������
                                         , inGoodsName          :=   TRIM (inObjectCode :: TVarChar) :: TVarChar  -- ������
                                         , inGoodsInfoName      :=   inGoodsInfoName                 :: TVarChar  --
                                         , inGoodsSizeName      :=   ''                              :: TVarChar  --
                                         , inCompositionName    :=   inCompositionName
                                         , inLineFabricaName    :=   '-'                :: TVarChar  --
                                         , inLabelName          :=   inLabelName  --
                                         , inAmount             :=   inAmount           :: TFloat    -- ����������
                                         , inPriceJur           :=   inOperPrice        :: TFloat    -- ���� ��.��� ������
                                         , inCountForPrice      :=   1                  :: TFloat    -- ���� �� ����������
                                         , inOperPriceList      :=   inOperPriceList    :: TFloat    -- ���� �� ������
                                         , inisCode             :=   FALSE                           -- �� �������� ��� ������--
                                         , inSession            :=   (-1 * vbUserId)    :: TVarChar  -- ������ ������������
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.01.20         *
*/

-- ����
