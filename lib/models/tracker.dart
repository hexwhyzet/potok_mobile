import 'package:potok/models/storage.dart';
import 'package:potok/models/ticket.dart';

class TrackerManager {
  int currentIndex = 0;
  Storage ticketStorage;

  TrackerManager({this.ticketStorage});

  updateView(int index) {
    ticketStorage.getObject(index).isViewed = true;
  }

  getTracker(int index) {
    return Tracker(ticket: ticketStorage.getObject(index));
  }

  sendBack({int threshold = 10}) async {
    var ctr = 0;
    for (var i = ticketStorage.size() - 1; i > 0; i--) {
      if (!ticketStorage.getObject(i).isReturned &&
          ticketStorage.getObject(i).isViewed) ctr += 1;
    }
    if (ctr > threshold) {
      var unsentTickets = [];
      for (var i = ticketStorage.size() - 1; i > 0; i--) {
        if (!ticketStorage.getObject(i).isReturned &&
            ticketStorage.getObject(i).isViewed) ctr += 1;
        unsentTickets.add(ticketStorage.getObject(i));
      }
      unsentTickets.sublist(0, unsentTickets.length - 2);
      // striping 2 last viewed pictures to that user can return
      await returnTickets(unsentTickets).then((value) {
        for (Ticket ticket in unsentTickets) {
          ticket.isReturned = true;
        }
      }, onError: (e) {
        print("Failed to return tickets");
      });
    }
  }
}

class Tracker {
  final Ticket ticket;

  Tracker({this.ticket});

  updateShare() {
    ticket.isShared = true;
  }

  updateLike(bool isLiked) {
    ticket.isLiked = isLiked;
  }
}
