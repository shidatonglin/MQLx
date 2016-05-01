//+------------------------------------------------------------------+
//|                                                  CommentBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Files\FileBin.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JCommentBase : public CObject
  {
protected:
   string            m_comment;
public:
                     JCommentBase(void);
                    ~JCommentBase(void);
   virtual void      Init(string comment);
   string            Text();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCommentBase::JCommentBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCommentBase::~JCommentBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCommentBase::Init(string comment)
  {
   m_comment=comment;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string JCommentBase::Text(void)
  {
   return m_comment;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\comment\Comment.mqh"
#else
#include "..\..\mql4\comment\Comment.mqh"
#endif
//+------------------------------------------------------------------+
