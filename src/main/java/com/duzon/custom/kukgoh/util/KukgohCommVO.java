package com.duzon.custom.kukgoh.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class KukgohCommVO {
	public String TableName;
	public List<String> columnName = new ArrayList<>();
	public List<Map<String, Object>> data = new ArrayList<Map<String, Object>>();
	public String interfaceNm;
	public String transactionNm;
	public String getInterfaceNm() {
		return interfaceNm;
	}

	public void setInterfaceNm(String interfaceNm) {
		this.interfaceNm = interfaceNm;
	}

	public String getTransactionNm() {
		return transactionNm;
	}

	public void setTransactionNm(String transactionNm) {
		this.transactionNm = transactionNm;
	}

	public String getTableName() {
		return TableName;
	}

	public void setTableName(String tableName) {
		TableName = tableName;
	}

	public List<String> getColumnName() {
		return columnName;
	}

	public void setColumnName(List<String> columnName) {
		this.columnName = columnName;
	}

	public List<Map<String, Object>> getData() {
		return data;
	}

	public void setData(List<Map<String, Object>> data) {
		this.data = data;
	}
}
