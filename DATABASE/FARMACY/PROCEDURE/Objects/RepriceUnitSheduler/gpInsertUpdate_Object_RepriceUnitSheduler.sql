DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RepriceUnitSheduler (Integer, Integer, Integer, Boolean, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RepriceUnitSheduler(
 INOUT ioId                 Integer,    -- ��
    IN inJuridicalId        Integer, 
    IN inPercentDifference  Integer, 
    IN inVAT20              Boolean,
    IN inPercentRepriceMax  Integer, 
    IN inPercentRepriceMin  Integer, 
    IN inEqualRepriceMax    Integer, 
    IN inEqualRepriceMin    Integer, 
    IN inSession            TVarChar   -- ������
)
AS
$BODY$
    DECLARE vbPlanAmount TFloat;
    DECLARE vbUserId Integer;
BEGIN
    -- ���������� ������������
    vbUserId := inSession;

    -- ���� ����� ������ ����
    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT * FROM ObjectLink WHERE DescId = zc_ObjectLink_RepriceUnitSheduler_Juridical() 
                                           AND ChildObjectId = inJuridicalId)
      THEN
        RAISE EXCEPTION '������.�� ������ ��. ���� <%> ������� ��� �������', (SELECT ValueData FROM Object WHERE Id = inJuridicalId);
      END IF;
    ELSE
      IF EXISTS(SELECT * FROM ObjectLink WHERE DescId = zc_ObjectLink_RepriceUnitSheduler_Juridical() 
                                           AND ObjectId <> ioId
                                           AND ChildObjectId = inJuridicalId)
      THEN
        RAISE EXCEPTION '������.�� ������ ��. ���� <%> ������� ��� �������', (SELECT ValueData FROM Object WHERE Id = inJuridicalId);
      END IF;    
    END IF;
        
    -- ���������/�������� <������> �� ��
    ioId := lpInsertUpdate_Object (ioId, zc_Object_RepriceUnitSheduler(), 0, '');

    -- ��������� ����� � <���� ��. ����>
    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RepriceUnitSheduler_Juridical(), ioId, inJuridicalId);
        
    --��������� 
    PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RepriceUnitSheduler_PercentDifference(), ioId, inPercentDifference);

    --��������� 
    PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_RepriceUnitSheduler_VAT20(), ioId, inVAT20);
    
    --��������� 
    PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMax(), ioId, inPercentRepriceMax);

    --��������� 
    PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMin(), ioId, inPercentRepriceMin);

    --��������� 
    PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMax(), ioId, inEqualRepriceMax);

    --��������� 
    PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMin(), ioId, inEqualRepriceMin);
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RepriceUnitSheduler (Integer, Integer, Integer, Boolean, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������ �.�.
 22.10.18        *
 */
