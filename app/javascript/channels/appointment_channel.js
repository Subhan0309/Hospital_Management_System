// import consumer from "./consumer";

// document.addEventListener('DOMContentLoaded', () => {
//   const doctorId = document.body.getAttribute('data-doctor-id');
//   const patientId = document.body.getAttribute('data-patient-id');
//   const OAS_id=document.body.getAttribute('data-OAS-id');

//   if (doctorId) {
//     // Subscribe to the doctor's channel
//     consumer.subscriptions.create({ channel: "AppointmentChannel", doctor_id: doctorId }, {
//       connected() {
//         console.log(`Connected to doctor channel ${doctorId}`);
//       },

//       disconnected() {
//         // Called when the subscription has been terminated by the server
//       },

//       received(data) {
//         handleAppointmentUpdate(data);
//       }
//     });
//   }

//   if (patientId) {
//     // Subscribe to the patient's channel
//     consumer.subscriptions.create({ channel: "AppointmentChannel", doctor_id: patientId }, {
//       connected() {
//         console.log(`Connected to patient channel ${patientId}`);
//       },

//       disconnected() {
//         // Called when the subscription has been terminated by the server
//       },

//       received(data) {
//         handleAppointmentUpdate(data);
//       }
//     });
//   }

//   if (OAS_id) {
//     // Subscribe to the patient's channel
//     consumer.subscriptions.create({ channel: "AppointmentChannel", OAS_id: OAS_id }, {
//       connected() {
//         console.log(`Connected to oas channel ${OAS_id}`);
//       },

//       disconnected() {
//         // Called when the subscription has been terminated by the server
//       },

//       received(data) {
//         handleAppointmentUpdate(data);
//       }
//     });
//   }

  
// });

// function handleAppointmentUpdate(data) {
//   console.log('Received data:', data);

//   const calendarElement = document.getElementById("calender");
//   if (calendarElement) {
//     const appointmentDate = new Date(data.appointment.date).toISOString().split('T')[0];
//     const dateElement = calendarElement.querySelector(`[data-date="${appointmentDate}"]`);
//     const doctorId = document.body.getAttribute('data-doctor-id');

//     console.log(data);
//     if (data.doctor_id !== doctorId) {
//       // Ignore updates for other doctors
//       return;
//     }

//     if (data.action === 'destroy') {
//       if (dateElement) {
//         const appointmentElement = dateElement.querySelector(`#appointment_${data.appointment.id}`);
//         if (appointmentElement) {
//           appointmentElement.remove();
//           console.log('Destroyed appointment:', data);
//         }
//       }
//     } else if (data.action === 'create') {
//       if (dateElement) {
//         dateElement.insertAdjacentHTML('beforeend', data.appointment.html);
//         console.log('Created appointment:', data);
//       }
//     } else if (data.action === 'update') {
//       if (dateElement) {
//         const appointmentElement = dateElement.querySelector(`#appointment_${data.appointment.id}`);
//         if (appointmentElement) {
//           appointmentElement.outerHTML = data.appointment.html;
//           console.log('Updated appointment:', data);
//         }
//       }
//     }
//   }
// }


import consumer from "./consumer";

document.addEventListener('DOMContentLoaded', () => {
  const doctorId = document.body.getAttribute('data-doctor-id');
  const patientId = document.body.getAttribute('data-patient-id');
  const OASId = document.body.getAttribute('data-oas-id');
  const Userrole = document.body.getAttribute('data-role');

  console.log("Ids are "+doctorId +" "+patientId+" "+OASId ,Userrole  );

  if (!Userrole && doctorId) {
    // Subscribe to the doctor's channel
    consumer.subscriptions.create({ channel: "AppointmentChannel", doctor_id: doctorId }, {
      connected() {
       alert(`Connected to doctor channel ${doctorId}`);
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        console.log("I am logging from the doctor having id "+ doctorId +" adn appointment data "+ data.appointment.doctor_id);
        if (data.appointment.doctor_id == doctorId) {
         
          handleAppointmentUpdate(data);
        }
      }
    });
  }

  else if (!Userrole && patientId) {
    // Subscribe to the patient's channel
    consumer.subscriptions.create({ channel: "AppointmentChannel", patient_id: patientId }, {
      connected() {
        alert(`Connected to patient channel ${patientId}`);
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        if (data.appointment.patient_id == patientId) {
          handleAppointmentUpdate(data);
        }
      }
    });
  }

  else if (Userrole && OASId) {
    console.log("owner hai bhai ");
    // Subscribe to the OAS channel
    consumer.subscriptions.create({ channel: "AppointmentChannel", role: Userrole }, {
      connected() {
       alert(`Connected to OAS channel ${OASId}`);
      },
      disconnected() {
        // Called when the subscription has been terminated by the server
        console.log(`not Connected to OAS channel ${OASId}`);
      },
      received(data) {
        console.log("owner krein ga receive");
        if (data.appointment.doctor_id == doctorId || data.appointment.patient_id == patientId) {
          console.log("Hello awais");
          handleAppointmentUpdate(data);
        }
      }
    });
  }

});

function handleAppointmentUpdate(data) {
  console.log('Received data:', data);

  const calendarElement = document.getElementById("calender");
  if (calendarElement) {
    const appointmentDate = new Date(data.appointment.date).toISOString().split('T')[0];
    const dateElement = calendarElement.querySelector(`[data-date="${appointmentDate}"]`);

    if (data.action === 'destroy') {
      if (dateElement) {
        const appointmentElement = dateElement.querySelector(`#appointment_${data.appointment.id}`);
        if (appointmentElement) {
          appointmentElement.remove();
          alert('Destroyed appointment:', data);
        }
      }
    } else if (data.action === 'create') {
      if (dateElement) {
        dateElement.insertAdjacentHTML('beforeend', data.appointment.html);
       alert('Created appointment:', data);
      }
    } else if (data.action === 'update') {
      if (dateElement) {
        const appointmentElement = dateElement.querySelector(`#appointment_${data.appointment.id}`);
        if (appointmentElement) {
          appointmentElement.outerHTML = data.appointment.html;
         alert('Updated appointment:', data);
        }
      }
    }
  }
}
