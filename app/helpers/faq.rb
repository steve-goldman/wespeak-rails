module Faq
  DATA = [
    [ "What is WeSpeak?",

      "WeSpeak is a social network where groups of people can speak as
      one.  Here's how it works.  Group members create
      <em>statements</em> for the group to consider.  New statements
      are known as <em>#{StatementStates.name(:alive).downcase}</em>.
      The statements that get enough support from other users go up
      for a vote and become
      <em>#{StatementStates.name(:voting).downcase}</em> statements.
      Statements that don't get enough support become
      <em>#{StatementStates.name(:dead).downcase}</em> statements.  At
      the end of a vote, if enough members voted YES, the statement
      becomes a <em>#{StatementStates.name(:accepted).downcase}</em>
      statement and updates the group profile page.  Statements that
      don't get enough YES votes become
      <em>#{StatementStates.name(:rejected).downcase}</em> statements.
      That's it!"

    ],
    [ "What is a statement?",

      "A statement is a piece of speech.  It can be
      a #{StatementTypes.name_from_sym(:update).downcase}, which
      appears in the group's timeline.  It can also be something that
      would change the group's profile if it
      is #{StatementStates.name(:accepted).downcase} by the group,
      such
      as #{StatementTypes.name_from_sym(:profile_image).downcase}, #{StatementTypes.name_from_sym(:tagline).downcase},
      participation requirements, or rules."

    ],
    [ "Is WeSpeak participation anonymous?",

      "WeSpeak uses pseudonyms.  We refer to them as usernames."

    ],
    [ "How do I know when it's time to vote?",

      "By default, WeSpeak will email you when voting begins or ends
      in a group that you are active in or following.  If you disable
      this, the <em>#{StatementStates.name(:voting).downcase}</em> tab
      in your feed or group pages will indicate if statements that you
      haven't voted on yet are open for voting."

    ],
    [ "I created a statement.  How can I get other members to support it?",

      "Get the word out!  Email a link to the statement to your
      friends.  Post it on your Facebook.  Tweet it.  Ask your friends
      to do the same.  It's your responsibility to find <em>grass
      roots support</em> for your statements."

    ],
    [ "Can I delete a statement I created?",

      "No."

    ],
    [ "When I support a statement, is that kept private?  What about my votes?",

      "No.  All activity that you do on WeSpeak -- including creating
      statements, supporting statements, and voting on statements --
      is publicly associated with your username."

    ],
    [ "How are groups created?",

      "Any user may create a group.  Start by clicking the <em>create
      a group</em> link at the top."

    ],
    [ "Who is in charge of a group?",

      "No one.  The user who created the group sets the
      initial #{StatementTypes.name_from_sym(:display_name).downcase},
      #{StatementTypes.name_from_sym(:profile_image).downcase},
      #{StatementTypes.name_from_sym(:tagline).downcase},
      participation requirements, and rules.  After that, the group is
      in charge of making changes."

    ],
    [ "Who may participate in a group?",

      "Anyone who meets the participation requirements for the group
      may participate.  The possible requirements are:" +
      "<ul>" +
      "<li><strong>An Email Address</strong> -- Members must have at least one email address associated with their WeSpeak account.  This is required for all groups.</li>" +
      "<li><strong>Email Address Domain</strong> -- Members must have an email address associated with their WeSpeak account that matches one of the domains for the group.  This is optional for groups.</li>" +
      "<li><strong>Location</strong> -- Members must be physically located in the geographical region required by the group.  This is optional for groups.</li>" +
      "<li><strong>Invitations</strong> -- Members must be invited by another active member.  This is optional for groups.</li>" +
      "</ul>"

    ],
    [ "What does <em>active member</em> mean?",

      "Active members are eligible to create statements, support
      statements created since they've been active, and vote on
      statements for which voting began since they've been active.
      Doing any of these things automatically extends how long the
      member will be active for.  This can also be done by clicking
      the <em>extend membership</em> button on the group page.  The
      active status expires if a member does not participate within
      the
      <em>#{RuleTypes.display_name(:inactivity_timeout).downcase}</em>
      for the group."

    ],
    [ "I proposed a change, but I don't see it in the profile.  Where is it?",

      "New statements are known as
      <em>#{StatementStates.name(:alive).downcase}</em>.  On the group
      profile page, click the
      <em>#{StatementStates.name(:alive).downcase}</em> tab.  Your
      statement will be there."

    ],
    [ "I joined a group, but I cannot support a statement or participate in a vote.  Why not?",

      "You may only support statements created <em>after</em> you
      joined the group or re-activated your membership.  You may only
      vote on statements for which voting began <em>after</em> you
      joined the group or re-activated your membership."

    ],
    [ "What should I do about an offensive statement in a group?",

      "Don't support it.  If it gets enough support without you, vote
      against it.  If you think the statement may be <em>illegal
      speech</em>, please contact us."

    ],
    [ "Can someone be kicked out of a group?",

      "No."

    ],
  ]
end
