
op(p4,
  loop(i4,
    loop(j4,
      loop(s4,
        if(active_found=0,
          if(largest_abs.l(w3) eq ((WW.l(p4,i4,j4,s4,w3) - WWhat(p4,i4,j4,s4,w3))/QEU(p4,i4)/100) or largest_abs.l(w3) eq (-(WW.l(p4,i4,j4,s4,w3) - WWhat(p4,i4,j4,s4,w3))/QEU(p4,i4)/100),
            active_found=1;
            signWWpc(p4,i4,j4,s4,w3,p3,c3) = sign(WW.l(p4,i4,j4,s4,w3) - WWhat(p4,i4,j4,s4,w3));
            diffWWpc(iter, p4,i4,j4,s4,w3,p3,c3) = abs(WW.l(p4,i4,j4,s4,w3) - WWhat(p4,i4,j4,s4,w3));
            );
          );
        );
      );
    );
  );

loop(c4,
  loop(j4,
        if(active_found=0,
          if(largest_abs.l(w3) eq ((Slack.l(c4,j4,w3) - Slackhat(c4,j4,w3))/D(c4,j4,w3)) or largest_abs.l(w3) eq (-(Slack.l(c4,j4,w3) - Slackhat(c4,j4,w3))/D(c4,j4,w3)),
            active_found=1;
            signSlackpc(c4,j4,w3,p3,c3) = sign(Slack.l(c4,j4,w3) - Slackhat(c4,j4,w3));
            diffSlackpc(iter, c4,j4,w3,p3,c3) = abs(Slack.l(c4,j4,w3) - Slackhat(c4,j4,w3));
            );
          );
    );
  );


loop(p4,
  loop(i4$(ORD(I4) eq 4),
    loop(j4$(ord(j4) eq 5),
      loop(s4,
        if(active_found=0,
          if(largest_abs.l(w3) eq (theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3))/QEU(p4,i4)/5 or largest_abs.l(w3) eq -(theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3))/QEU(p4,i4)/5,
            active_found=1;
            signthetapc(p4,i4,j4,s4,w3,p3,c3) = sign(theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3));
            
            );
          );
        );
      );
    );
  );
loop(p4,
  loop(i4$(ORD(I4) ne 4),
    loop(j4,
      loop(s4,
        if(active_found=0,
          if(largest_abs.l(w3) eq (theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3))/QEU(p4,i4)/100 or largest_abs.l(w3) eq -(theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3))/QEU(p4,i4)/100,
            active_found=1;
            signthetapc(p4,i4,j4,s4,w3,p3,c3) = sign(theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3));
            
            );
          );
        );
      );
    );
  );

loop(p4,
  loop(i4,
    loop(j4$(ord(j4) ne 5),
      loop(s4,
        if(active_found=0,
          if(largest_abs.l(w3) eq (theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3))/QEU(p4,i4)/100 or largest_abs.l(w3) eq -(theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3))/QEU(p4,i4)/100,
            active_found=1;
            signthetapc(p4,i4,j4,s4,w3,p3,c3) = sign(theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3));
            
            );
          );
        );
      );
    );
  );



















loop(p4,
  loop(i4,
    loop(j4,
      loop(s4,
        if(active_found=0,
          if(largest_abs.l(w3) eq ((WW.l(p4,i4,j4,s4,w3) - WWhat(p4,i4,j4,s4,w3))/QEU(p4,i4)/100) or largest_abs.l(w3) eq (-(WW.l(p4,i4,j4,s4,w3) - WWhat(p4,i4,j4,s4,w3))/QEU(p4,i4)/100),
            active_found=1;
            signWWrp(p4,i4,j4,s4,w3,r3,p3) = sign(WW.l(p4,i4,j4,s4,w3) - WWhat(p4,i4,j4,s4,w3));
            diffWWrp(iter, p4,i4,j4,s4,w3,r3,p3) = abs(WW.l(p4,i4,j4,s4,w3) - WWhat(p4,i4,j4,s4,w3));
            );
          );
        );
      );
    );
  );

loop(c4,
  loop(j4,
        if(active_found=0,
          if(largest_abs.l(w3) eq ((Slack.l(c4,j4,w3) - Slackhat(c4,j4,w3))/D(c4,j4,w3)) or largest_abs.l(w3) eq (-(Slack.l(c4,j4,w3) - Slackhat(c4,j4,w3))/D(c4,j4,w3)),
            active_found=1;
            signSlackrp(c4,j4,w3,r3,p3) = sign(Slack.l(c4,j4,w3) - Slackhat(c4,j4,w3));
            diffSlackrp(iter, c4,j4,w3,r3,p3) = abs(Slack.l(c4,j4,w3) - Slackhat(c4,j4,w3));
            );
          );
    );
  );


loop(p4,
  loop(i4$(ORD(I4) eq 4),
    loop(j4$(ord(j4) eq 5),
      loop(s4,
        if(active_found=0,
          if(largest_abs.l(w3) eq (theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3))/QEU(p4,i4)/5 or largest_abs.l(w3) eq -(theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3))/QEU(p4,i4)/5,
            active_found=1;
            signthetarp(p4,i4,j4,s4,w3,r3,p3) = sign(theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3));
            
            );
          );
        );
      );
    );
  );
loop(p4,
  loop(i4$(ORD(I4) ne 4),
    loop(j4,
      loop(s4,
        if(active_found=0,
          if(largest_abs.l(w3) eq (theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3))/QEU(p4,i4)/100 or largest_abs.l(w3) eq -(theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3))/QEU(p4,i4)/100,
            active_found=1;
            signthetarp(p4,i4,j4,s4,w3,r3,p3) = sign(theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3));
            
            );
          );
        );
      );
    );
  );

loop(p4,
  loop(i4,
    loop(j4$(ord(j4) ne 5),
      loop(s4,
        if(active_found=0,
          if(largest_abs.l(w3) eq (theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3))/QEU(p4,i4)/100 or largest_abs.l(w3) eq -(theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3))/QEU(p4,i4)/100,
            active_found=1;
            signthetarp(p4,i4,j4,s4,w3,r3,p3) = sign(theta.l(p4,i4,j4,s4,w3) - thetahat(p4,i4,j4,s4,w3));
            
            );
          );
        );
      );
    );
  );

