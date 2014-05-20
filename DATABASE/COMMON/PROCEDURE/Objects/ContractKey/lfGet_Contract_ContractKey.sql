-- Function: lfGet_Contract_ContractKey (Integer)

DROP FUNCTION IF EXISTS lfGet_Contract_ContractKey (Integer);

CREATE OR REPLACE FUNCTION lfGet_Contract_ContractKey(
    IN inContractKeyId       Integer
)
  RETURNS Integer AS
$BODY$
   DECLARE vbDateStart TDateTime;
BEGIN

     -- !!!���� ��� ��������� "���������" � "��������" ���������!!!


     -- �������� ������������ <���� � ������� ��������� �������> + �� ��������� + "����������" �����
     vbDateStart:= (SELECT MAX (ObjectDate_Start.ValueData) AS DateStart
                    FROM ObjectLink AS ObjectLink_Contract_ContractKey
                         INNER JOIN ObjectDate AS ObjectDate_Start
                                               ON ObjectDate_Start.ObjectId = ObjectLink_Contract_ContractKey.ObjectId
                                              AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                         INNER JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_Contract_ContractKey.ObjectId
                                                             AND Object_Contract.isErased = FALSE
                                                             AND Object_Contract.ValueData <> '-'
                    WHERE ObjectLink_Contract_ContractKey.ChildObjectId = inContractKeyId
                      AND ObjectLink_Contract_ContractKey.DescId = zc_ObjectLink_Contract_ContractKey()
                   );

     IF vbDateStart IS NULL
     THEN
         -- ��� ��� �������� ������������ <���� � ������� ��������� �������>
         vbDateStart:= (SELECT MAX (ObjectDate_Start.ValueData) AS DateStart
                        FROM ObjectLink AS ObjectLink_Contract_ContractKey
                             INNER JOIN ObjectDate AS ObjectDate_Start
                                                   ON ObjectDate_Start.ObjectId = ObjectLink_Contract_ContractKey.ObjectId
                                                  AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                        WHERE ObjectLink_Contract_ContractKey.ChildObjectId = inContractKeyId
                          AND ObjectLink_Contract_ContractKey.DescId = zc_ObjectLink_Contract_ContractKey()
                       );
         -- �������� "�����" ������� � ������������ <���� � ������� ��������� �������>
         RETURN (SELECT MAX (ObjectLink_Contract_ContractKey.ObjectId)
                 FROM ObjectLink AS ObjectLink_Contract_ContractKey
                      INNER JOIN ObjectDate AS ObjectDate_Start
                                            ON ObjectDate_Start.ObjectId = ObjectLink_Contract_ContractKey.ObjectId
                                           AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                                           AND ObjectDate_Start.ValueData = vbDateStart
                 WHERE ObjectLink_Contract_ContractKey.ChildObjectId = inContractKeyId
                   AND ObjectLink_Contract_ContractKey.DescId = zc_ObjectLink_Contract_ContractKey()
                );
     ELSE
         -- �������� "�����" ������� � ������������ <���� � ������� ��������� �������> + �� ��������� + "����������" �����
         RETURN (SELECT MAX (ObjectLink_Contract_ContractKey.ObjectId)
                 FROM ObjectLink AS ObjectLink_Contract_ContractKey
                      INNER JOIN ObjectDate AS ObjectDate_Start
                                            ON ObjectDate_Start.ObjectId = ObjectLink_Contract_ContractKey.ObjectId
                                           AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                                           AND ObjectDate_Start.ValueData = vbDateStart
                      INNER JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_Contract_ContractKey.ObjectId
                                                          AND Object_Contract.isErased = FALSE
                                                          AND Object_Contract.ValueData <> '-'
                 WHERE ObjectLink_Contract_ContractKey.ChildObjectId = inContractKeyId
                   AND ObjectLink_Contract_ContractKey.DescId = zc_ObjectLink_Contract_ContractKey()
                );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_Contract_ContractKey (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.05.14                                        * add InvNumber <> '-'
 25.04.14                                        *
*/

-- ����
-- SELECT * FROM lfGet_Contract_ContractKey (1)
