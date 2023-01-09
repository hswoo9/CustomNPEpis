package neos.cmm.util.code.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.code.service.SequenceService;

@Service("SequenceService")
public class SequenceServiceImpl implements SequenceService {
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Override 
	//@Transactional(propagation = Propagation.REQUIRES_NEW)
	//어노테이션 트랜잭션처리할 경우 context에서 transactionManger가 선언되지 않아 오류가 나 주석처리함 2016.03.22 윤장호
	public String getSequence(String seqName ) {
		System.out.println("seqName : " + seqName);
		return (String) commonSql.select("CommonCodeInfo.getSequence", seqName);
	}
	
}
