-- Function: gpInsertUpdate_Movement_Currency_https()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Currency_https (TDateTime, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Currency_https(
    IN inOperDate                 TDateTime , -- ���� ���������
    IN inAmount_text              TVarChar  , -- ����
    IN inInternalName             TVarChar  , -- ������ ��� ������� �������� ����
    IN inSession                  TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbCurrencyFromId Integer;
   DECLARE vbCurrencyToId   Integer;
   DECLARE vbPaidKindId     Integer;
   DECLARE vbAmount         TFloat;
   DECLARE vbAmount_find    TFloat;
   DECLARE vbParValue       TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Currency());
     
     -- ����� ������
     vbCurrencyFromId:= zc_Enum_Currency_Basis();
     -- ����� ������
     vbCurrencyToId:= (SELECT Object_Currency_View.Id FROM Object_Currency_View WHERE Object_Currency_View.InternalName ILIKE inInternalName);
     -- �����
     vbPaidKindId:= zc_Enum_PaidKind_FirstForm();

     -- 
     vbParValue:= CASE WHEN 1=0 AND CEIL (zfConvert_StringToFloat (inAmount_text) * 10000.0) = zfConvert_StringToFloat (inAmount_text) * 10000.0
                            THEN 1
                       WHEN CEIL (zfConvert_StringToFloat (inAmount_text) * 1000000.0) = zfConvert_StringToFloat (inAmount_text) * 1000000.0
                            THEN 100
                       WHEN CEIL (zfConvert_StringToFloat (inAmount_text) * 100000000.0) = zfConvert_StringToFloat (inAmount_text) * 100000000.0
                            THEN 10000
                       WHEN CEIL (zfConvert_StringToFloat (inAmount_text) * 10000000000.0) = zfConvert_StringToFloat (inAmount_text) * 10000000000.0
                            THEN 1000000
                  END;
     --
     vbAmount:= CASE WHEN vbParValue = 1
                          THEN zfConvert_StringToFloat (inAmount_text)
                     WHEN vbParValue = 100
                          THEN zfConvert_StringToFloat (inAmount_text) * 100
                     WHEN vbParValue = 10000
                          THEN zfConvert_StringToFloat (inAmount_text) * 10000
                     WHEN vbParValue = 1000000
                          THEN zfConvert_StringToFloat (inAmount_text) * 1000000
                END;

     -- ��������
     IF COALESCE (vbCurrencyToId, 0) = 0
     THEN
        RAISE EXCEPTION '������.��� �������� <%> �� ������� <������>.', inInternalName;
     END IF;
     

        /*RAISE EXCEPTION '������.<%>   <%>   <%>   <%>    <%>'
        , inInternalName
        , vbCurrencyFromId
        , vbCurrencyToId
        , vbPaidKindId
        , inOperDate
        ;*/

     -- �����
     vbAmount_find:= (SELECT MovementItem.Amount
                      FROM Movement
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.ObjectId   = vbCurrencyFromId
                           INNER JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                             ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_CurrencyTo.DescId         = zc_MILinkObject_Currency()
                                                            AND MILinkObject_CurrencyTo.ObjectId       = vbCurrencyToId
                           INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_PaidKind.DescId         = zc_MILinkObject_PaidKind()
                                                            AND MILinkObject_PaidKind.ObjectId       = vbPaidKindId
                      WHERE Movement.DescId = zc_Movement_Currency()
                        AND Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', inOperDate) AND inOperDate -- - INTERVAL '1 DAY'
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                      ORDER BY Movement.OperDate DESC
                      LIMIT 1
                     );

     -- ���� �� �����
     IF COALESCE (vbAmount_find, 0) <> vbAmount
     /*AND NOT EXISTS (SELECT 1
                    FROM Movement
                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.ObjectId   = vbCurrencyFromId
                         INNER JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                           ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_CurrencyTo.DescId         = zc_MILinkObject_Currency()
                                                          AND MILinkObject_CurrencyTo.ObjectId       = vbCurrencyToId
                         INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                           ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_PaidKind.DescId         = zc_MILinkObject_PaidKind()
                                                          AND MILinkObject_PaidKind.ObjectId       = vbPaidKindId
                    WHERE Movement.DescId   = zc_Movement_Currency()
                      AND Movement.OperDate = inOperDate
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                   )*/
     THEN

         PERFORM gpInsertUpdate_Movement_Currency (ioId                       := (SELECT Movement.Id
                                                                                  FROM Movement
                                                                                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                                                              AND MovementItem.DescId     = zc_MI_Master()
                                                                                                              AND MovementItem.ObjectId   = vbCurrencyFromId
                                                                                       INNER JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                                                                                         ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                                                                                        AND MILinkObject_CurrencyTo.DescId         = zc_MILinkObject_Currency()
                                                                                                                        AND MILinkObject_CurrencyTo.ObjectId       = vbCurrencyToId
                                                                                       INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                                                                         ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                                                                        AND MILinkObject_PaidKind.DescId         = zc_MILinkObject_PaidKind()
                                                                                                                        AND MILinkObject_PaidKind.ObjectId       = vbPaidKindId
                                                                                  WHERE Movement.DescId = zc_Movement_Currency()
                                                                                    AND Movement.OperDate = inOperDate
                                                                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                                  LIMIT 1
                                                                                 )
                                                 , inInvNumber                := COALESCE ((SELECT Movement.InvNumber
                                                                                            FROM Movement
                                                                                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                                                                                        AND MovementItem.ObjectId   = vbCurrencyFromId
                                                                                                 INNER JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                                                                                                   ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                                                                                                  AND MILinkObject_CurrencyTo.DescId         = zc_MILinkObject_Currency()
                                                                                                                                  AND MILinkObject_CurrencyTo.ObjectId       = vbCurrencyToId
                                                                                                 INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                                                                                   ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                                                                                  AND MILinkObject_PaidKind.DescId         = zc_MILinkObject_PaidKind()
                                                                                                                                  AND MILinkObject_PaidKind.ObjectId       = vbPaidKindId
                                                                                            WHERE Movement.DescId   = zc_Movement_Currency()
                                                                                              AND Movement.OperDate = inOperDate
                                                                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                                            LIMIT 1
                                                                                           )
                                                                                         , CAST (NEXTVAL ('Movement_currency_seq') AS TVarChar)
                                                                                         )
                                                 , inOperDate                 := inOperDate
                                                 , inAmount                   := vbAmount
                                                 , inParValue                 := vbParValue
                                                 , inComment                  := 'bank.gov.ua'
                                                 , inCurrencyFromId           := vbCurrencyFromId
                                                 , inCurrencyToId             := vbCurrencyToId
                                                 , inPaidKindId               := vbPaidKindId
                                                 , inSession                  := inSession
                                                  );

         IF 1 < (SELECT COUNT(*)
                        FROM Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.ObjectId   = vbCurrencyFromId
                             INNER JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                               ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_CurrencyTo.DescId         = zc_MILinkObject_Currency()
                                                              AND MILinkObject_CurrencyTo.ObjectId       = vbCurrencyToId
                             INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                               ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_PaidKind.DescId         = zc_MILinkObject_PaidKind()
                                                              AND MILinkObject_PaidKind.ObjectId       = vbPaidKindId
                        WHERE Movement.DescId   = zc_Movement_Currency()
                          AND Movement.OperDate = inOperDate
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                   )
         THEN
            RAISE EXCEPTION '������.<%>   <%>   <%>   <%>    <%>   <%>   <%>    <%>'
            , inInternalName
            , vbCurrencyFromId
            , vbCurrencyToId
            , vbPaidKindId
            , inOperDate
            , CHR (13)
            , vbAmount_find
            , vbAmount
            ;
         END IF;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 20.01.20                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Currency_https (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inCurrencyFromId:= 1, inCurrencyFromBasisId:= 1, inBusinessId:= 2, inPaidKindId:= 1,  inInfoMoneyId:= 0, inCurrencyFromId:= 0, inSession:= '2')
