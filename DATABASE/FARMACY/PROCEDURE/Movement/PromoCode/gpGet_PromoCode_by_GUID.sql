-- ��������� ������ � ���������� �� ���������
DROP FUNCTION IF EXISTS gpGet_PromoCode_by_GUID(TVarChar, out Integer, out TVarChar, out TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PromoCode_by_GUID (
    IN  inPromoGUID                     TVarChar,              -- ����� ���
    OUT outPromoCodeID                  Integer,               -- ��� �����
    OUT outPromoName                    TVarChar,              -- �������� �����
    OUT outPromoCodeChangePercent       TFloat,                -- ������� ������
    IN  inSession                       TVarChar               -- ������ ������������
)
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbUnitKey TVarChar;
    
    DECLARE vbStatusID                  Integer;
    DECLARE vbStartPromo                TDateTime;
    DECLARE vbEndPromo                  TDateTime;
    DECLARE vbForSite                   Boolean;
    DECLARE vbOneCode                   Boolean;
    DECLARE vbBuySite                   Boolean;
    DECLARE vbPromoCodeChangePercent    TFloat;
    DECLARE vbPromoID                   Integer;
    DECLARE vbPromoChecked              Boolean;
    DECLARE vbPromoErased               Boolean;
    DECLARE vbPromoName                 TVarChar;
    DECLARE vbBayerName                 TVarChar;
BEGIN

    outPromoCodeID            := 0;
    outPromoName              := '';
    outPromoCodeChangePercent := 0;
    
    -- �������� �������������
    vbUserId := lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        vbUnitKey := '0';
    END IF;   
        vbUnitId := vbUnitKey::Integer;

    IF NOT EXISTS(SELECT * FROM MovementItemString PromoCode_GUID
                    WHERE PromoCode_GUID.descid = zc_MIString_GUID()
                      AND PromoCode_GUID.valuedata = inPromoGUID) THEN
        RAISE EXCEPTION '��������� �������� �� ������';
    END IF;

    -- �������� ������ �� ���������
    SELECT
        Promo.statusid,
        StartPromo.valuedata as StartPromo,
        EndPromo.valuedata as EndPromo,
        ForSite.valuedata as ForSite,
        OneCode.valuedata as OneCode,
        BuySite.valuedata as BuySite,
        ChangePercent.valuedata as ChangePercent,
        PromoCode.id,
        CASE WHEN PromoCode.amount > 0 THEN TRUE ELSE FALSE END as PromoCodeChecked,
        PromoCode.iserased,
        PromoAction.valuedata,
        MIString_Bayer.ValueData
    INTO
        vbStatusID, vbStartPromo, vbEndPromo, vbForSite, vbOneCode, vbBuySite, vbPromoCodeChangePercent,
        vbPromoID, vbPromoChecked, vbPromoErased, vbPromoName, vbBayerName
    FROM
        MovementItemString PromoCode_GUID
        INNER JOIN MovementItem PromoCode
                ON PromoCode_GUID.movementitemid = PromoCode.id AND PromoCode.descid = zc_MI_Sign()
        INNER JOIN Movement Promo
                ON PromoCode.movementid = Promo.id
        INNER JOIN MovementDate StartPromo
                ON Promo.id = StartPromo.movementid AND StartPromo.descid = zc_MovementDate_StartPromo()
        INNER JOIN MovementDate EndPromo
                ON Promo.id = EndPromo.movementid AND EndPromo.descid = zc_MovementDate_EndPromo()
        LEFT JOIN MovementBoolean ForSite
                ON Promo.id = ForSite.movementid AND ForSite.descid = zc_MovementBoolean_Electron()
        LEFT JOIN MovementBoolean OneCode
                ON Promo.id = OneCode.movementid AND OneCode.descid = zc_MovementBoolean_One()
        LEFT JOIN MovementBoolean BuySite
                ON Promo.id = BuySite.movementid AND BuySite.descid = zc_MovementBoolean_BuySite()
        LEFT JOIN MovementFloat ChangePercent
                ON Promo.id = ChangePercent.movementid AND ChangePercent.descid = zc_MovementFloat_ChangePercent()
        LEFT JOIN MovementLinkObject LinkPromoAction
                ON LinkPromoAction.movementid = Promo.id AND LinkPromoAction.descid = zc_MovementLinkObject_PromoCode()
        LEFT JOIN Object PromoAction
                ON PromoAction.id = LinkPromoAction.objectid
        LEFT JOIN MovementItemString MIString_Bayer
                ON PromoCode.ID = MIString_Bayer.MovementItemId AND MIString_Bayer.DescId = zc_MIString_Bayer()
    WHERE
        PromoCode_GUID.descid = zc_MIString_GUID() AND PromoCode_GUID.valuedata = inPromoGUID;

    IF vbStatusID = zc_Enum_Status_UnComplete() THEN
        RAISE EXCEPTION '��������� ����� ��������������';
    END IF;

    IF vbStatusID = zc_Enum_Status_Erased() THEN
        RAISE EXCEPTION '��������� ����� �������';
    END IF;

    IF CURRENT_DATE < vbStartPromo THEN
        RAISE EXCEPTION '����� ��� �� ��������';
    END IF;

    IF CURRENT_DATE > vbEndPromo THEN
        RAISE EXCEPTION '����� ��� ���������';
    END IF;

    IF vbPromoErased THEN
        RAISE EXCEPTION '�������� ������';
    END IF;

    IF NOT vbPromoChecked THEN
        RAISE EXCEPTION '�������� ���������';
    END IF;
    
    IF vbBuySite THEN
        RAISE EXCEPTION '�������� ������������ ������ ��� ������� �� �����';
    END IF;

    IF vbForSite and COALESCE(vbBayerName, '') = '' THEN
        RAISE EXCEPTION '�������� �� ����� �� �����';
    END IF;
    
    -- �������� �� ������������ ���������
    IF vbOneCode OR vbForSite THEN
        IF EXISTS(SELECT * FROM MovementFloat 
                    WHERE descid = zc_MovementFloat_MovementItemId() AND valuedata = vbPromoID) THEN
            RAISE EXCEPTION '������ �������� ��� �����������';
        END IF;
    END IF;    

    -- ���� ���� ���� �� ���� ����, �� ��������� ������ �� ������� ���� � ���� ������
    IF EXISTS(SELECT * 
              FROM MovementItem PromoCode
                  INNER JOIN Movement Promo ON Promo.id = PromoCode.movementid
                  INNER JOIN MovementItem PromoUnit ON Promo.id = PromoUnit.movementid AND promounit.descid = zc_MI_Child()
              WHERE PromoCode.id = vbPromoID AND PromoUnit.objectid IS NOT NULL) THEN
        
        IF NOT EXISTS(SELECT * 
                      FROM MovementItem PromoCode
                          INNER JOIN Movement Promo ON Promo.id = PromoCode.movementid
                          INNER JOIN MovementItem PromoUnit ON Promo.id = PromoUnit.movementid AND promounit.descid = zc_MI_Child()
                      WHERE PromoCode.id = vbPromoID AND promounit.amount > 0 AND PromoUnit.objectid = vbUnitId) THEN
            RAISE EXCEPTION '������ ������������� �� ������ � ������ ����������� � �����';      
        END IF;    
    END IF;

    outPromoCodeID            := vbPromoID;
    outPromoName              := vbPromoName;
    outPromoCodeChangePercent := vbPromoCodeChangePercent;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.   ������������ �.�.   ������ �.�.
 07.08.18                                                                                                        *
 16.06.18                                                                                                        *
 02.02.18                                                                                        *
*/

-- ����
-- select * from gpGet_PromoCode_by_GUID(inPromoGUID := '894ac34f' ,  inSession := '3354092');
