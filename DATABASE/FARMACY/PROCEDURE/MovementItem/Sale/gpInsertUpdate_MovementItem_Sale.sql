-- Function: gpInsertUpdate_MovementItem_Sale()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
 INOUT ioPrice               TFloat    , -- ����
 INOUT ioPriceSale           TFloat    , -- ���� ��� ������
    IN inChangePercent       TFloat    , -- % ������
    IN inNDSKindId           Integer   , -- ���
   OUT outSumm               TFloat    , -- �����
   OUT outIsSp               Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbIsInsert  Boolean;
   DECLARE vbIsDeferred Boolean;
   DECLARE vbUnitId    Integer;
   DECLARE vbSPKindId  Integer;
   DECLARE vbAmount    TFloat;
   DECLARE vbGoodsName TVarChar;
   DECLARE vbSaldo     TFloat;
   DECLARE vbPriceCalc TFloat;
   DECLARE vbPersent   TFloat;
   DECLARE vbisVIPforSales Boolean;
   DECLARE vbAmountVIP TFloat;
   DECLARE vbDeviationsPrice1303 TFloat;   
   DECLARE vbPriceSale TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
    vbUserId := inSession;

    IF COALESCE (inNDSKindId, 0) = 0
    THEN
      inNDSKindId := COALESCE((SELECT Object_Goods_Main.NDSKindId FROM  Object_Goods_Retail
                                      LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                               WHERE Object_Goods_Retail.Id = inGoodsId), zc_Enum_NDSKind_Medical());
    
    END IF;
    
    -- �������� ������� �������
    SELECT COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean
         , Movement_Sale.UnitId
         , Movement_Sale.SPKindId
    INTO vbIsDeferred
       , vbUnitId
       , vbSPKindId
    FROM Movement_Sale_View AS Movement_Sale
         LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                   ON MovementBoolean_Deferred.MovementId = Movement_Sale.Id
                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
    WHERE Movement_Sale.Id = inMovementId;

    -- �������� ������ �� ������ ���������� � ������� ��� 20%, ��� ����. 1303
    IF vbSPKindId = zc_Enum_SPKind_1303() AND vbUserId <> 235009    --  ������ �. �.
       AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
            -- �������� ������ �� ������ ���������� � ������� ��� 20%, ��� ����. 1303
       THEN
            --
            IF EXISTS (SELECT 1
                       FROM ObjectLink
                            INNER JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                   ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink.ChildObjectId
                                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                                  AND ObjectFloat_NDSKind_NDS.ValueData = 20
                       WHERE ObjectLink.ObjectId = inGoodsId
                         AND ObjectLink.DescId = zc_ObjectLink_Goods_NDSKind())
               THEN
                   RAISE EXCEPTION '������. ������ �� ������ ������ �� ���� 1303 �� ������� ���=20 ����. (����� ��� ����������� !!!)';
            END IF;

            SELECT CASE WHEN tt.Price < 100 THEN tt.Price * 1.1 -- 1.25
                         WHEN tt.Price >= 100 AND tt.Price < 500 THEN tt.Price * 1.1 -- 1.2
                         WHEN tt.Price >= 500 AND tt.Price < 1000 THEN tt.Price * 1.1 -- 1.15
                         WHEN tt.Price >= 1000 THEN tt.Price * 1.1
                    END :: TFloat AS PriceCalc
                  , CASE WHEN tt.Price < 100 THEN 10 --25
                         WHEN tt.Price >= 100 AND tt.Price < 500 THEN 10 --20
                         WHEN tt.Price >= 500 AND tt.Price < 1000 THEN 10 --15
                         WHEN tt.Price >= 1000 THEN 10
                    END :: TFloat AS Persent
            INTO vbPriceCalc, vbPersent
             FROM (SELECT CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN MIFloat_Price.ValueData
                               ELSE (MIFloat_Price.ValueData * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData,1)/100))::TFloat    -- � ������ ��������������  ���� � ���, � ��������� ��� ���
                          END AS Price   -- ���� c ���
                        , ROW_NUMBER() OVER (ORDER BY Container.Id DESC) AS ord   -- ���� ������� �������� �� ��������� ������
                   FROM Container
                      LEFT OUTER JOIN ContainerLinkObject AS CLI_MI
                                                          ON CLI_MI.ContainerId = Container.Id
                                                         AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                      LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

                      LEFT OUTER JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode :: Integer
                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()

                      LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                ON MovementBoolean_PriceWithVAT.MovementId =  MI_Income.MovementId
                                               AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                   ON MovementLinkObject_NDSKind.MovementId = MI_Income.MovementId
                                                  AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                      LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                            ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                           AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                   WHERE Container.ObjectId = inGoodsId
                     AND Container.DescId = zc_Container_Count()
                     AND Container.WhereObjectId = vbUnitId
                     AND COALESCE (Container.Amount,0 ) > 0
                     AND COALESCE (MIFloat_Price.ValueData ,0) > 0
                   ) AS tt
             WHERE tt.Ord = 1;

            -- ��������  ���� < 100��� � ����������� ���������� �������� ���� �������� 25%. �� 100 �� 500 ��� � �������� �� ���� 20%. ³� 500 �� 1000 � 15%. ����� 1000 ��� �������� �� ���� 10%.
            IF (COALESCE(ioId, 0) = 0) AND (COALESCE (vbPriceCalc,0) <> 0)
            THEN
              ioPriceSale := trunc(vbPriceCalc * 10) / 10;
            ELSEIF (COALESCE (vbPriceCalc,0) < ioPriceSale) AND (COALESCE (vbPriceCalc,0) <> 0)
               THEN
                   IF vbPersent = 25 THEN  RAISE EXCEPTION '������. ������ �� ������ ������ �� ���� 1303 � �������� ����� 25 ��������� (��� ������ � ��������� ����� �� 100���).% ������� PrintScreen ������ � ������� � ��������� �� Skype ������ ��������� ���  ����������� ���� ���������� (����� ����������� - �������� ����� ��������� �� �������)', Chr(13)||Chr(10); END IF;
                   IF vbPersent = 20 THEN  RAISE EXCEPTION '������. ������ �� ������ ������ �� ���� 1303 � �������� ����� 20 ��������� (��� ������ � ��������� ����� �� 100��� �� 500���).% ������� PrintScreen ������ � ������� � ��������� �� Skype ������ ��������� ���  ����������� ���� ���������� (����� ����������� - �������� ����� ��������� �� �������)', Chr(13)||Chr(10); END IF;
                   IF vbPersent = 15 THEN  RAISE EXCEPTION '������. ������ �� ������ ������ �� ���� 1303 � �������� ����� 15 ��������� (��� ������ � ��������� ����� �� 500��� �� 1000���).% ������� PrintScreen ������ � ������� � ��������� �� Skype ������ ��������� ���  ����������� ���� ���������� (����� ����������� - �������� ����� ��������� �� �������)', Chr(13)||Chr(10); END IF;
                   IF vbPersent = 10 THEN  RAISE EXCEPTION '������. ������ �� ������ ������ �� ���� 1303 � �������� ����� 10 ��������� (��� ������ � ��������� ����� ����� 1000���).% ������� PrintScreen ������ � ������� � ��������� �� Skype ������ ��������� ���  ����������� ���� ���������� (����� ����������� - �������� ����� ��������� �� �������)', Chr(13)||Chr(10); END IF;
            END IF;
            
            SELECT COALESCE(ObjectFloat_CashSettings_DeviationsPrice1303.ValueData, 1)    AS DeviationsPrice1303
            INTO vbDeviationsPrice1303
            FROM Object AS Object_CashSettings
                 LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DeviationsPrice1303
                                       ON ObjectFloat_CashSettings_DeviationsPrice1303.ObjectId = Object_CashSettings.Id 
                                      AND ObjectFloat_CashSettings_DeviationsPrice1303.DescId = zc_ObjectFloat_CashSettings_DeviationsPrice1303()
            WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
            LIMIT 1;
            
            SELECT T1.PriceSale, T1.PriceSaleIncome  
            INTO vbPriceSale, vbPriceCalc                          
            FROM gpSelect_GoodsSPRegistry_1303_Unit (inUnitId := vbUnitId, inGoodsId := inGoodsId, inisCalc := True, inSession := inSession) AS T1;
            
            IF COALESCE(vbPriceSale, 0) = 0
            THEN
               RAISE EXCEPTION '���� �������. ����� �� ������ � ������� ������� ���. ������� 1303';
            END IF;

            -- ����������� �� ����
            IF (COALESCE (vbPriceCalc,0) < ioPriceSale) AND (COALESCE (trunc(vbPriceCalc * 10) / 10, 0) > 0)
            THEN
               ioPriceSale := trunc(vbPriceCalc * 10) / 10;
            END IF;

            IF vbPriceSale < ioPriceSale 
            THEN
                           
              IF (ioPriceSale / vbPriceSale * 100 - 100) <= COALESCE(vbDeviationsPrice1303, 1.0)
              THEN
                ioPriceSale := vbPriceSale;
              ELSE
                 RAISE EXCEPTION '%',  '���� ������� !'||Chr(13)||Chr(10)|| 
                           '��������� ���� ���� ��� �� ������� ������� ���. ������� 1303'||Chr(13)||Chr(10)||Chr(13)||Chr(10)||
                           '������������ ���� ���������� ������ ���� - '||zfConvert_FloatToString(vbPriceSale)||'���.'||Chr(13)||Chr(10)|| 
                           '� ��� �����. ���� ��� ������� �� ���� 1303 - '||zfConvert_FloatToString(ioPriceSale)||'���.';              
              END IF;
            END IF;

    END IF;

/*    IF (COALESCE(ioId, 0) = 0)
    THEN
      RAISE EXCEPTION '������. % % ', ioPriceSale, vbPriceCalc;
    END IF;*/
    
    
    IF EXISTS(SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession) WHERE GoodsId = inGoodsId)
    THEN
      vbisVIPforSales := True;
      vbAmountVIP := COALESCE ((SELECT Amount FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession) WHERE GoodsId = inGoodsId), 0);        
    ELSE
      vbisVIPforSales := False;
      vbAmountVIP := 0;    
    END IF;
    
    -- ��������� ��������� ���������� ��� ��������� �����
    IF vbIsDeferred = TRUE AND COALESCE (ioId, 0) <> 0
    THEN
      vbAmount := COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId), 0);
    ELSE
      vbAmount := 0;
    END IF;
    
    IF vbisVIPforSales = TRUE AND vbAmount + vbAmountVIP < inAmount
    THEN
      IF vbAmount + vbAmountVIP = 0
      THEN
        RAISE EXCEPTION '������. �� ������ �� ���������� ������ ������� ��� �������.';    
      ELSE
        RAISE EXCEPTION '������. ������� ��� ������� ���������� ������ % ��. �� ��������� ��������� % ��.', vbAmount + vbAmountVIP, inAmount;          
      END IF;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       AND vbUserId <> 235009 AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       AND EXISTS(SELECT 1 FROM MovementLinkMovement AS MLM_Child
                      INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                    ON MovementLinkObject_SPKind.MovementId = MLM_Child.MovementId
                                                   AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                   AND COALESCE (MovementLinkObject_SPKind.ObjectId, 0) = zc_Enum_SPKind_1303()
                      INNER JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Child.MovementChildId
                  WHERE MLM_Child.MovementId = inMovementId
                    AND MLM_Child.descId = zc_MovementLinkMovement_Child())
    THEN
      RAISE EXCEPTION '������. �� ��������� ������� <���� (����.1303)> ��������� ��������� ���������.';
    END IF;

    --���������� ������� ��������� � ���.�������, �� ����� ���.
    outIsSp:= COALESCE (
             (SELECT CASE WHEN COALESCE(MovementString_InvNumberSP.ValueData,'') <> '' OR
                                COALESCE(MovementString_MedicSP.ValueData,'') <> '' OR
                                COALESCE(MovementString_MemberSP.ValueData,'') <> '' OR
                               -- COALESCE(MovementDate_OperDateSP.ValueData,Null) <> Null OR
                                COALESCE(MovementLinkObject_PartnerMedical.ObjectId,0) <> 0 THEN True
                           ELSE FALSE
                      END
              FROM Movement
                          LEFT JOIN MovementString AS MovementString_InvNumberSP
                                 ON MovementString_InvNumberSP.MovementId = Movement.Id
                                AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                          LEFT JOIN MovementString AS MovementString_MedicSP
                                 ON MovementString_MedicSP.MovementId = Movement.Id
                                AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
                          LEFT JOIN MovementString AS MovementString_MemberSP
                                 ON MovementString_MemberSP.MovementId = Movement.Id
                                AND MovementString_MemberSP.DescId = zc_MovementString_MemberSP()
                          LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                 ON MovementDate_OperDateSP.MovementId = Movement.Id
                                AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                  ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                 AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Sale())
              , False)  :: Boolean ;

    -- �������� �� 1 ����� ���������� �������� � ����������
    -- ����  ������� ��������� � ���.������� = TRUE . �� � ���. ������ ���� 1 ������
    IF outIsSp = TRUE
    THEN
         IF (SELECT COUNT(*) FROM MovementItem
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.Id <> ioId
               AND MovementItem.IsErased = FALSE
               AND MovementItem.Amount > 0) >= 1
            THEN
                 RAISE EXCEPTION '������.� ��������� ����� ���� ������ 1 ��������.';
            END IF;
    END IF;

    --��������� ���� �������
    IF COALESCE(inChangePercent,0) <> 0 THEN
       ioPrice:= ROUND( COALESCE(ioPriceSale,0) - (COALESCE(ioPriceSale,0)/100 * inChangePercent) ,2);
    END IF;

    --��������� �����
    outSumm := ROUND(COALESCE(inAmount,0)*COALESCE(ioPrice,0),2);

     -- ���������
    ioId := lpInsertUpdate_MovementItem_Sale (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inPrice              := ioPrice
                                            , inPriceSale          := ioPriceSale
                                            , inChangePercent      := inChangePercent
                                            , inSumm               := outSumm
                                            , inisSp               := COALESCE(outIsSp,False) ::Boolean
                                            , inNDSKindId          := inNDSKindId 
                                            , inUserId             := vbUserId
                                             );

    -- ��������� ��������� ���������� ��� ��������� �����
    IF vbIsDeferred = TRUE AND inAmount <> vbAmount
    THEN

      --�������� �� �� ��� �� �� ������� ������ ��� ���� �� �������
      SELECT MI_Sale.GoodsName
           , COALESCE(SUM(Container.Amount),0) + vbAmount
      INTO
          vbGoodsName
        , vbSaldo
      FROM MovementItem_Sale_View AS MI_Sale
          LEFT OUTER JOIN Container ON MI_Sale.GoodsId = Container.ObjectId
                                   AND Container.WhereObjectId = vbUnitId
                                   AND Container.DescId = zc_Container_Count()
                                   AND Container.Amount > 0
      WHERE MI_Sale.Id = ioId
        AND MI_Sale.isErased = FALSE
      GROUP BY MI_Sale.GoodsId
             , MI_Sale.GoodsName
             , MI_Sale.Amount
      HAVING COALESCE (MI_Sale.Amount, 0) > (COALESCE (SUM (Container.Amount) ,0) + vbAmount);

      IF (COALESCE(vbGoodsName,'') <> '')
      THEN
         RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ������� <%> ������, ��� ���� �� ������� <%>.', vbGoodsName, inAmount, vbSaldo;
      END IF;

      IF inAmount < vbAmount
      THEN
        -- ��������� VIP ��� ��� �������         
        IF EXISTS(SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession) 
                  WHERE GoodsId = inGoodsId)
        THEN
          PERFORM gpInsertUpdate_MovementItem_Check_VIPforSales (inUnitId   := vbUnitId
                                                               , inGoodsId  := inGoodsId
                                                               , inAmount   := vbAmount
                                                               , inSession  := inSession
                                                                );                  
        END IF;

        -- ����������� ������ ��������
        PERFORM lpDelete_MovementItemContainerOne (inMovementId := inMovementId
                                                 , inMovementItemId := ioId);
      END IF;

      -- ���������� ��������
      PERFORM lpComplete_Movement_Sale(inMovementId, -- ���� ���������
                                       ioId,         -- ���� ���������� ���������
                                       vbUserId);    -- ������������
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.  ������ �.�.
 11.05.20                                                                                      *               
 26.11.19         *
 01.08.19                                                                                      *
 05.06.18         *
 09.02.17         *
 13.10.15                                                                         *
*/

-- select * from gpInsertUpdate_MovementItem_Sale(ioId := 0 , inMovementId := 29186995 , inGoodsId := 30802 , inAmount := 1 , ioPrice := 204.6 , ioPriceSale := 204.6 , inChangePercent := 100 , inNDSKindId := 9 ,  inSession := '3');