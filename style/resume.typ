#import "@preview/metalogo:1.2.0": LaTeX

#let resume(
  author: "",
  author-position: left,
  personal-info-position: left,
  pronouns: "",
  location: "",
  political-affiliation: "",
  email: "",
  github: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  orcid: "",
  accent-color: "#26428b",
  // font: "MiSans",
  font: "Source Han Serif",
  paper: "a4",
  author-font-size: 25pt,
  font-size: 11pt,
  photo: "",
  body,
) = {
  // Sets document metadata
  set document(author: author, title: author)

  // Document-wide formatting, including font and margins
  set text(
    // LaTeX style font
    font: font,
    size: font-size,
    lang: "zh",
    // Disable ligatures so ATS systems do not get confused when parsing fonts.
    ligatures: false,
  )

  // Reccomended to have 0.5in margin on all sides
  set page(
    margin: 0.6in,
    paper: paper,
  )

  // Link styles
  show link: underline


  // Small caps for section titles
  show heading.where(level: 2): it => [
    #pad(top: 0pt, bottom: -10pt, [#smallcaps(it.body)])
    #line(length: 100%, stroke: 1pt)
  ]

  // Accent Color Styling
  show heading: set text(
    fill: rgb(accent-color),
  )

  show link: set text(
    fill: rgb(accent-color),
  )

  // Name will be aligned left, bold and big
  show heading.where(level: 1): it => [
    #set align(author-position)
    #set text(
      weight: 700,
      size: author-font-size,
    )
    #pad(it.body)
  ]

  // Level 1 Heading
  [
    = #(author)
  ]

  // Personal Info Helper
  let contact-item(value, prefix: "", link-type: "") = {
    if value != "" {
      if link-type != "" {
        link(link-type + value)[_#(prefix + value)_]
      } else {
        value
      }
    }
  }

  // Personal Info
  align(personal-info-position)[
    #{
      let items = (
        contact-item(pronouns),
        contact-item(phone),
        contact-item(location),
        contact-item(political-affiliation),
      )
      items.filter(x => x != none).join("  |  ")
    }
  ]

  align(personal-info-position)[
    #{
      let items = (
        contact-item(email, link-type: "mailto:"),
        contact-item(github, link-type: "https://"),
        contact-item(linkedin, link-type: "https://"),
        contact-item(personal-site, link-type: "https://"),
      )
      items.filter(x => x != none).join("  |  ")
    }
  ]

  if type(photo) == content {
    place(
      right + top,
    )[
      #box(
        width: 6em,
        height: 20em,
        inset: 0pt,
        outset: 0pt,
        photo,
      )
    ]
  }
  // Main body.
  set par(justify: true)

  body
}

// Generic two by two component for resume
#let generic-two-by-two(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
) = {
  [
    #top-left #h(1fr) #top-right \
    #bottom-left #h(1fr) #bottom-right
  ]
}

// Generic one by two component for resume
#let generic-one-by-two(
  left: "",
  right: "",
) = {
  [
    #left #h(1fr) #right
  ]
}

// Cannot just use normal --- ligature becuase ligatures are disabled for good reasons
#let dates-helper(
  start-date: "",
  end-date: "",
) = {
  start-date + " " + $dash.em$ + " " + end-date
}

// Section components below
#let edu(
  institution: "",
  level: "",
  dates: "",
  degree: "",
  gpa: "",
  location: "",
  // Makes dates on upper right like rest of components
  consistent: false,
) = {
  if consistent {
    // edu-constant style (dates top-right, location bottom-right)
    generic-two-by-two(
      top-left: strong(institution) + ", " + level,
      top-right: dates,
      bottom-left: degree,
      bottom-right: location,
    )
  } else {
    // original edu style (location top-right, dates bottom-right)
    generic-two-by-two(
      top-left: strong(institution) + ", " + level,
      top-right: location,
      bottom-left: degree,
      bottom-right: dates,
    )
  }
}

#let work(
  title: "",
  dates: "",
  company: "",
  location: "",
) = {
  generic-two-by-two(
    top-left: strong(title),
    top-right: dates,
    bottom-left: company,
    bottom-right: location,
  )
}

#let project(
  role: "",
  name: "",
  url: "",
  dates: "",
) = {
  generic-one-by-two(
    left: {
      if role == "" {
        [*#name* #if url != "" and dates != "" [ (#link("https://" + url)[_#url _])]]
      } else {
        [*#role*, #name #if url != "" and dates != "" [ (#link("https://" + url)[_#url _])]]
      }
    },
    right: {
      if dates == "" and url != "" {
        link("https://" + url)[_#url _]
      } else {
        dates
      }
    },
  )
}

#let certificates(
  name: "",
  issuer: "",
  url: "",
  date: "",
) = {
  [
    *#name*, #issuer
    #if url != "" {
      [ (#link("https://" + url)[_#url _])]
    }
    #h(1fr) #date
  ]
}

#let extracurriculars(
  activity: "",
  dates: "",
) = {
  generic-one-by-two(
    left: strong(activity),
    right: dates,
  )
}
