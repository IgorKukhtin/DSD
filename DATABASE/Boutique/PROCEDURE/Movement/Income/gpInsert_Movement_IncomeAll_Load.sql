-- Function: gpInsert_Movement_IncomeAll_Load()

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
   DECLARE vbUserId      Integer;
   DECLARE vbCurrencyId  Integer;
   DECLARE vbPartnerId   Integer;
   DECLARE vbUnitId      Integer;
   DECLARE vbBrandId     Integer;
   DECLARE vbPeriodId       Integer;
   DECLARE vbMovementId     Integer;
   DECLARE vbGoodsGroupParentId Integer;
   DECLARE vbGoodsGroupId   Integer;
   DECLARE vbCurrencyValue  TFloat;
   DECLARE vbParValue       TFloat;
   
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

     -- �� �������������
     vbUnitId := (SELECT Object.Id 
                  FROM Object
                  WHERE Object.DescId = zc_Object_Unit()
                     AND UPPER (TRIM (Object.ValueData) ) LIKE UPPER('%'||TRIM ('������� PODIUM')||'%')    -- ������� PODIUM ���� ��� ��������� � ����� ��������
                  );

     -- �� ������
     vbCurrencyId := zc_Currency_Basis();

     IF COALESCE (vbCurrencyId,0) = 0
     THEN 
         RAISE EXCEPTION '������.�� ������� <������> <%>.', inCurrencyName;
     END IF;
                          
     -- �� ����������
     vbPartnerId := (SELECT Object.Id 
                     FROM Object
                     WHERE Object.DescId = zc_Object_Partner()
                        AND UPPER (TRIM (Object.ValueData) ) LIKE UPPER('%'||TRIM (inBrandName||' ' ||inPeriodName)||'%')
                     );

     IF COALESCE (vbPartnerId,0) = 0
     THEN
         -- 
         vbBrandId := (SELECT Object.Id 
                       FROM Object
                       WHERE Object.DescId = zc_Object_Brand()
                          AND UPPER (TRIM (Object.ValueData) ) = UPPER (TRIM (inBrandName))
                       );
         IF COALESCE (vbBrandId, 0) = 0
         THEN
             -- ��������
             vbBrandId := (SELECT tmp.ioId 
                           FROM gpInsertUpdate_Object_Brand (ioId          := 0
                                                           , ioCode        := 0
                                                           , inName        := TRIM (inBrandName)
                                                           , inCountryBrandId := 0
                                                           , inSession     := inSession
                                                            ) AS tmp);
         END IF;
         --
         vbPeriodId := (SELECT Object.Id 
                        FROM Object
                        WHERE Object.DescId = zc_Object_Period()
                           AND UPPER (TRIM(Object.ValueData)) =  UPPER (TRIM(LEFT (inPeriodName, length(inPeriodName)-4)))
                        );
                       
         -- ���������
         SELECT tmp.ioId
                INTO vbPartnerId
         FROM gpInsertUpdate_Object_Partner (ioId            := 0
                                           , ioCode          := 0
                                           , inBrandId       := vbBrandId
                                           , inFabrikaId     := 0
                                           , inPeriodId      := vbPeriodId
                                           , inPeriodYear    := RIGHT (TRIM (inPeriodName), 4) ::TFloat
                                           , inSession       := inSession
                                           ) AS tmp;
     END IF;

     -- ������� ����� �������� �� ����� ����, ���������, �������
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MLO_From
                                                         ON MLO_From.MovementId = Movement.Id
                                                        AND MLO_From.DescId = zc_MovementLinkObject_From()
                                                        AND MLO_From.ObjectId = vbPartnerId
                           INNER JOIN MovementLinkObject AS MLO_To
                                                         ON MLO_To.MovementId = Movement.Id
                                                        AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                        AND MLO_To.ObjectId = vbUnitId
               
                           INNER JOIN MovementLinkObject AS MLO_CurrencyDocument
                                                         ON MLO_CurrencyDocument.MovementId = Movement.Id
                                                        AND MLO_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                                                        AND MLO_CurrencyDocument.ObjectId = vbCurrencyId
                      WHERE Movement.DescId = zc_Movement_Income()
                        AND Movement.OperDate = inOperDate
                      LIMIT 1);

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

     -- ������ ������
     vbGoodsGroupId:= (SELECT Object.Id 
                       FROM Object 
                       WHERE Object.DescId = zc_Object_GoodsGroup()
                         AND LOWER (Object.ValueData) = LOWER (COALESCE (TRIM (inGoodsGroupName), '')));
     --
     IF COALESCE (vbGoodsGroupId, 0) = 0
     THEN
         -- ��������
         vbGoodsGroupId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_GoodsGroup (ioId          := 0
                                                                                 , ioCode        := 0
                                                                                 , inName        := COALESCE (TRIM (inGoodsGroupName), '')
                                                                                 , inParentId    := 0
                                                                                 , inInfoMoneyId := 0
                                                                                 , inSession     := inSession
                                                                                   ) AS tmp);
     END IF;
     
     PERFORM gpInsertUpdate_MIEdit_Income(ioId                 :=   0  -- ���� ������� <������� ���������>
                                        , inMovementId         :=   vbMovementId
                                        , inGoodsGroupId       :=   vbGoodsGroupId
                                        , inMeasureId          :=   219                                    -- ��.
                                        , inJuridicalId        :=   0         -- ��.����(����)
                                        , ioGoodsCode          :=   NEXTVAL ('Object_Goods_seq')   ::Integer      -- ��� ������
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
                                        , inSession            :=   inSession  -- ������ ������������
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
