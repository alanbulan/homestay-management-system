package com.hms.vo;

import java.io.Serializable;
import java.util.List;

/**
 * 分页结果类
 */
public class PageResult<T> implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 当前页码
     */
    private Integer pageNum;
    
    /**
     * 每页大小
     */
    private Integer pageSize;
    
    /**
     * 总记录数
     */
    private Long total;
    
    /**
     * 总页数
     */
    private Integer pages;
    
    /**
     * 数据列表
     */
    private List<T> list;
    
    /**
     * 是否有上一页
     */
    private Boolean hasPreviousPage;
    
    /**
     * 是否有下一页
     */
    private Boolean hasNextPage;
    
    // 构造方法
    public PageResult() {}
    
    public PageResult(Integer pageNum, Integer pageSize, Long total, List<T> list) {
        this.pageNum = pageNum;
        this.pageSize = pageSize;
        this.total = total;
        this.list = list;
        
        // 计算总页数
        this.pages = (int) Math.ceil((double) total / pageSize);
        
        // 计算是否有上一页和下一页
        this.hasPreviousPage = pageNum > 1;
        this.hasNextPage = pageNum < pages;
    }
    
    // 静态工厂方法
    public static <T> PageResult<T> of(Integer pageNum, Integer pageSize, Long total, List<T> list) {
        return new PageResult<>(pageNum, pageSize, total, list);
    }
    
    public static <T> PageResult<T> empty(Integer pageNum, Integer pageSize) {
        return new PageResult<>(pageNum, pageSize, 0L, null);
    }
    
    // Getter和Setter方法
    public Integer getPageNum() {
        return pageNum;
    }
    
    public void setPageNum(Integer pageNum) {
        this.pageNum = pageNum;
    }
    
    public Integer getPageSize() {
        return pageSize;
    }
    
    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }
    
    public Long getTotal() {
        return total;
    }
    
    public void setTotal(Long total) {
        this.total = total;
    }
    
    public Integer getPages() {
        return pages;
    }
    
    public void setPages(Integer pages) {
        this.pages = pages;
    }
    
    public List<T> getList() {
        return list;
    }
    
    public void setList(List<T> list) {
        this.list = list;
    }
    
    public Boolean getHasPreviousPage() {
        return hasPreviousPage;
    }
    
    public void setHasPreviousPage(Boolean hasPreviousPage) {
        this.hasPreviousPage = hasPreviousPage;
    }
    
    public Boolean getHasNextPage() {
        return hasNextPage;
    }
    
    public void setHasNextPage(Boolean hasNextPage) {
        this.hasNextPage = hasNextPage;
    }
    
    /**
     * 判断是否为空
     */
    public boolean isEmpty() {
        return list == null || list.isEmpty();
    }
    
    /**
     * 获取数据大小
     */
    public int size() {
        return list == null ? 0 : list.size();
    }
    
    @Override
    public String toString() {
        return "PageResult{" +
                "pageNum=" + pageNum +
                ", pageSize=" + pageSize +
                ", total=" + total +
                ", pages=" + pages +
                ", listSize=" + size() +
                ", hasPreviousPage=" + hasPreviousPage +
                ", hasNextPage=" + hasNextPage +
                '}';
    }
}
