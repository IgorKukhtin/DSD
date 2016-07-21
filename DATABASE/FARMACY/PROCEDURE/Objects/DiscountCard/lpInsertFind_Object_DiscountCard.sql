-- Function: lpInsertFind_Object_DiscountCard (Integer, TVarChar, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_DiscountCard (Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_DiscountCard(
    IN inObjectId       Integer   , -- ��������� ���������� ����
    IN inValue          TVarChar  , -- � ���������� �����
    IN inUserId         Integer   
)
RETURNS Integer
AS
$BODY$
   DECLARE vbDiscountCardId Integer;
BEGIN

     -- ��������
     IF COALESCE (TRIM (inValue), '') = ''
     THEN
         RAISE EXCEPTION '������.�� ���������� � ���������� ����� <%>.', inValue;
     END IF;

     -- ������ ��������
     inValue:= TRIM (inValue);


     -- �������
     vbDiscountCardId:= (SELECT Object.Id
                         FROM Object 
                              INNER JOIN ObjectLink AS ObjectLink_Object
                                                    ON ObjectLink_Object.ObjectId = Object_DiscountCard.Id
                                                   AND ObjectLink_Object.DescId = zc_ObjectLink_DiscountCard_Object()
                                                   AND ObjectLink_Object.ChildObjectId = inObjectId
                         WHERE Object.ValueData = inValue
                           AND Object.DescId = zc_Object_DiscountCard()
                        );

     -- ���� �� �����
     IF COALESCE (vbDiscountCardId, 0) = 0
     THEN
         -- ��������� <������ �������� ������>
         vbDiscountCardId:= gpInsertUpdate_Object_DiscountCard (ioId      := 0
                                                              , inCode    := lfGet_ObjectCode(0, zc_Object_DiscountCard())
                                                              , inName    := inValue
                                                              , inObjectId:= inObjectId
                                                              , inSession := inUserId :: TVarChar
                                                               );
     END IF;


     -- ���������� ��������
     RETURN (vbDiscountCardId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.07.16                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_DiscountCard (inObjectId:= 1, inValue:= '', inUserId:= zfCalc_UserAdmin() :: Integer);
